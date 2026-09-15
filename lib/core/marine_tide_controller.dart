import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoastalLogEntry {
  final String id;
  final DateTime date;
  final String breakLocation;
  final double waterTempC;
  final double windSpeedKnots;
  final double waveHeightMeters;
  final int rating; // 1-5
  final String notes;

  CoastalLogEntry({
    required this.id,
    required this.date,
    required this.breakLocation,
    required this.waterTempC,
    required this.windSpeedKnots,
    required this.waveHeightMeters,
    required this.rating,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'breakLocation': breakLocation,
        'waterTempC': waterTempC,
        'windSpeedKnots': windSpeedKnots,
        'waveHeightMeters': waveHeightMeters,
        'rating': rating,
        'notes': notes,
      };

  factory CoastalLogEntry.fromJson(Map<String, dynamic> json) {
    return CoastalLogEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      breakLocation: json['breakLocation'] as String,
      waterTempC: (json['waterTempC'] as num).toDouble(),
      windSpeedKnots: (json['windSpeedKnots'] as num).toDouble(),
      waveHeightMeters: (json['waveHeightMeters'] as num).toDouble(),
      rating: json['rating'] as int,
      notes: json['notes'] as String,
    );
  }
}

class MarineTideController extends ChangeNotifier {
  static const String _prefsKeyLogs = 'fanvura_coastal_logs';
  static const String _prefsKeyHarbor = 'fanvura_selected_harbor';
  static const String _prefsKeyUnitMetric = 'fanvura_use_metric';

  final List<String> harborPresets = [
    'Biarritz Grand Plage',
    'Mavericks Point',
    'Bondi Beach Bay',
    'Nazaré North Canyon',
    'Jeffreys Bay Supertubes',
    'Pipeline North Shore',
  ];

  String _selectedHarbor = 'Biarritz Grand Plage';
  bool _useMetric = true;

  // Swell parameters
  double _waveHeight = 1.8; // meters
  double _swellPeriod = 13.0; // seconds
  double _windSpeed = 11.0; // knots
  String _windDirection = 'Offshore'; // Offshore, Cross-shore, Onshore

  // Coastal logs
  final List<CoastalLogEntry> _logs = [];

  String get selectedHarbor => _selectedHarbor;
  bool get useMetric => _useMetric;
  double get waveHeight => _waveHeight;
  double get swellPeriod => _swellPeriod;
  double get windSpeed => _windSpeed;
  String get windDirection => _windDirection;
  List<CoastalLogEntry> get logs => List.unmodifiable(_logs);

  MarineTideController() {
    _loadFromPreferences();
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _selectedHarbor = prefs.getString(_prefsKeyHarbor) ?? harborPresets.first;
      _useMetric = prefs.getBool(_prefsKeyUnitMetric) ?? true;

      final savedLogs = prefs.getString(_prefsKeyLogs);
      if (savedLogs != null && savedLogs.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(savedLogs) as List<dynamic>;
        _logs.clear();
        for (final item in decoded) {
          _logs.add(CoastalLogEntry.fromJson(item as Map<String, dynamic>));
        }
      } else {
        _populateDefaultLogs();
      }
      notifyListeners();
    } catch (_) {
      _populateDefaultLogs();
    }
  }

  void _populateDefaultLogs() {
    _logs.clear();
    _logs.addAll([
      CoastalLogEntry(
        id: '1',
        date: DateTime.now().subtract(const Duration(days: 1)),
        breakLocation: 'Biarritz Grand Plage',
        waterTempC: 18.5,
        windSpeedKnots: 8.0,
        waveHeightMeters: 1.6,
        rating: 5,
        notes: 'Glassy morning tide switch, clean right-handers with long peeling walls.',
      ),
      CoastalLogEntry(
        id: '2',
        date: DateTime.now().subtract(const Duration(days: 3)),
        breakLocation: 'Nazaré North Canyon',
        waterTempC: 16.0,
        windSpeedKnots: 15.2,
        waveHeightMeters: 2.8,
        rating: 4,
        notes: 'Heavy incoming spring swell, high tidal surge around midday.',
      ),
    ]);
  }

  Future<void> _saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_logs.map((e) => e.toJson()).toList());
    await prefs.setString(_prefsKeyLogs, jsonString);
  }

  void setHarbor(String harbor) async {
    _selectedHarbor = harbor;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKeyHarbor, harbor);
  }

  void toggleUnits() async {
    _useMetric = !_useMetric;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKeyUnitMetric, _useMetric);
  }

  void updateSwellConditions({
    double? waveHeight,
    double? swellPeriod,
    double? windSpeed,
    String? windDirection,
  }) {
    if (waveHeight != null) _waveHeight = waveHeight;
    if (swellPeriod != null) _swellPeriod = swellPeriod;
    if (windSpeed != null) _windSpeed = windSpeed;
    if (windDirection != null) _windDirection = windDirection;
    notifyListeners();
  }

  void addLog(CoastalLogEntry entry) {
    _logs.insert(0, entry);
    notifyListeners();
    _saveLogs();
  }

  void removeLog(String id) {
    _logs.removeWhere((item) => item.id == id);
    notifyListeners();
    _saveLogs();
  }

  // Tide status calculations
  // Semi-diurnal tide cycle is ~12 hours 25 minutes (745 minutes)
  double get tideCycleProgress {
    final now = DateTime.now();
    final totalMinutesToday = now.hour * 60 + now.minute;
    const cycleLengthMinutes = 745;
    return (totalMinutesToday % cycleLengthMinutes) / cycleLengthMinutes;
  }

  bool get isTideRising => tideCycleProgress < 0.5;

  String get tideStateLabel => isTideRising ? 'Flooding (Rising)' : 'Ebbing (Falling)';

  double get currentTideHeightMeters {
    // sinusoidal height between 0.6m and 3.8m
    final angle = tideCycleProgress * 2 * 3.141592653589793;
    final normalized = (1 - (angle).abs().remainder(3.141592653589793) / 3.141592653589793 * 2).abs();
    return 0.6 + normalized * 3.2;
  }

  Duration get timeToNextSlackWater {
    // Slack water occurs at the extremes (progress = 0.5 or 1.0)
    final progress = tideCycleProgress;
    double remainingRatio;
    if (progress < 0.5) {
      remainingRatio = 0.5 - progress;
    } else {
      remainingRatio = 1.0 - progress;
    }
    final remainingMinutes = (remainingRatio * 745).round();
    return Duration(minutes: remainingMinutes);
  }

  // Swell grading
  String get surfGrade {
    if (_windSpeed > 28) return 'Grade E - Blown Out Gale';
    if (_waveHeight > 4.5 && _swellPeriod > 16) return 'Grade S - Giant XXL Bomb';
    if (_windDirection == 'Offshore' && _swellPeriod >= 12 && _waveHeight >= 1.2) {
      return 'Grade A+ - World-Class Glass';
    }
    if (_windDirection == 'Offshore' || (_swellPeriod >= 10 && _windSpeed < 14)) {
      return 'Grade A - Clean & Lined Up';
    }
    if (_swellPeriod >= 8 && _windSpeed < 18) {
      return 'Grade B - Fun Cruiser Swell';
    }
    if (_windDirection == 'Onshore' && _windSpeed > 16) {
      return 'Grade D - Choppy & Slapped';
    }
    return 'Grade C - Moderate Beach Bump';
  }

  String get recommendedBoard {
    if (_waveHeight >= 3.5) return 'Gun / Step-Up (7\'6"+)';
    if (_waveHeight >= 2.0 && _swellPeriod >= 12) return 'Standard Performance Shortboard (6\'1")';
    if (_waveHeight >= 1.0 && _swellPeriod >= 9) return 'Fish / Twin Fin (5\'8")';
    return 'Log / Longboard or Soft-top (9\'0"+)';
  }

  double get energyKilojoules {
    // Wave energy density roughly ~ H^2 * T
    return (_waveHeight * _waveHeight * _swellPeriod * 0.98);
  }

  // Lunar / Tide Spring-Neap calculation
  // Synodic lunar cycle = 29.530588 days
  double get lunarPhaseRatio {
    // Fixed base new moon: 2026-01-18 17:52 UTC
    final baseNewMoon = DateTime.utc(2026, 1, 18, 17, 52);
    final now = DateTime.now().toUtc();
    final differenceDays = now.difference(baseNewMoon).inSeconds / 86400.0;
    final cycle = differenceDays % 29.530588;
    return cycle / 29.530588;
  }

  String get currentMoonPhaseName {
    final ratio = lunarPhaseRatio;
    if (ratio < 0.05 || ratio >= 0.95) return 'New Moon';
    if (ratio < 0.20) return 'Waxing Crescent';
    if (ratio < 0.30) return 'First Quarter';
    if (ratio < 0.45) return 'Waxing Gibbous';
    if (ratio < 0.55) return 'Full Moon';
    if (ratio < 0.70) return 'Waning Gibbous';
    if (ratio < 0.80) return 'Last Quarter';
    return 'Waning Crescent';
  }

  bool get isSpringTide {
    final ratio = lunarPhaseRatio;
    // Spring tides occur during New Moon (around 0.0/1.0) and Full Moon (around 0.5)
    return (ratio < 0.12 || ratio > 0.88 || (ratio > 0.38 && ratio < 0.62));
  }
}
