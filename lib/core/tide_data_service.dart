import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoastalLogEntry {
  final String location;
  final String condition;
  final double waveHeightM;
  final DateTime loggedAt;

  CoastalLogEntry({
    required this.location,
    required this.condition,
    required this.waveHeightM,
    required this.loggedAt,
  });
}

class TideDataService extends ChangeNotifier {
  String _selectedStation = 'Pacific Coast - Point Reyes';
  final double _currentTideMeters = 1.45;
  final bool _isRising = true;
  final int _nextSlackMinutes = 85;

  final List<CoastalLogEntry> _logs = [
    CoastalLogEntry(
      location: 'Mavericks Reef',
      condition: 'Clean offshore glass',
      waveHeightM: 2.8,
      loggedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    CoastalLogEntry(
      location: 'Ocean Beach Pier',
      condition: 'Choppy rising swell',
      waveHeightM: 1.5,
      loggedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  TideDataService() {
    _loadPrefs();
  }

  String get selectedStation => _selectedStation;
  double get currentTideMeters => _currentTideMeters;
  bool get isRising => _isRising;
  int get nextSlackMinutes => _nextSlackMinutes;
  List<CoastalLogEntry> get logs => _logs;

  void addLog(String location, String condition, double waveHeight) {
    _logs.insert(
      0,
      CoastalLogEntry(
        location: location,
        condition: condition,
        waveHeightM: waveHeight,
        loggedAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void switchStation(String station) {
    _selectedStation = station;
    _savePrefs();
    notifyListeners();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedStation = prefs.getString('fanvura_station') ?? 'Pacific Coast - Point Reyes';
    notifyListeners();
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fanvura_station', _selectedStation);
  }
}
