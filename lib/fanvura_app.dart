import 'dart:math';
import 'package:flutter/material.dart';
import 'theme/fanvura_theme.dart';
import 'models/coastal_log.dart';
import 'state/tide_scope.dart';
import 'painters/tide_sine_wave_painter.dart';

class FanvuraApp extends StatelessWidget {
  const FanvuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fanvura Marine Tides',
      debugShowCheckedModeBanner: false,
      theme: FanvuraTheme.themeData,
      home: const FanvuraShell(),
    );
  }
}

class FanvuraShell extends StatefulWidget {
  const FanvuraShell({super.key});

  @override
  State<FanvuraShell> createState() => _FanvuraShellState();
}

class _FanvuraShellState extends State<FanvuraShell> {
  int _selectedNavIndex = 0;
  double _tideProgress = 0.35;
  double _waterHeightM = 3.6;

  final List<CoastalLog> _logs = [
    CoastalLog(id: '1', location: 'Emerald Bay Pier', condition: 'Clean Rolling Glass', swellHeight: 1.8, time: '08:15 AM'),
    CoastalLog(id: '2', location: 'Point Break Reef', condition: 'Choppy Outflow', swellHeight: 2.4, time: '11:30 AM'),
    CoastalLog(id: '3', location: 'South Channel Inlet', condition: 'Slack High Water', swellHeight: 1.2, time: '03:45 PM'),
  ];

  @override
  Widget build(BuildContext context) {
    return TideScope(
      data: TideData(
        tidePhaseProgress: _tideProgress,
        currentHeightM: _waterHeightM,
        logs: _logs,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _getNavTitle(_selectedNavIndex),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: FanvuraTheme.ink,
            ),
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  color: FanvuraTheme.bg,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.tsunami_rounded, size: 36, color: FanvuraTheme.accent),
                      SizedBox(height: 12),
                      Text(
                        'FANVURA MARINE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: FanvuraTheme.ink,
                        ),
                      ),
                      Text(
                        'Coastal Tide & Swell Almanac',
                        style: TextStyle(fontSize: 12, color: FanvuraTheme.muted),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: FanvuraTheme.edge),
                _buildDrawerItem(0, 'Tide Clock Visualizer', Icons.access_time_filled_rounded),
                _buildDrawerItem(1, 'Marine Swell Forecast', Icons.water_rounded),
                _buildDrawerItem(2, 'Coastal Voyage Log', Icons.menu_book_rounded),
                _buildDrawerItem(3, 'Lunar Phase Guide', Icons.nightlight_round),
              ],
            ),
          ),
        ),
        body: _buildCurrentBody(),
      ),
    );
  }

  String _getNavTitle(int index) {
    switch (index) {
      case 0: return 'Tide Clock Visualizer';
      case 1: return 'Marine Swell Forecast';
      case 2: return 'Coastal Voyage Log';
      case 3: return 'Lunar Phase Guide';
      default: return 'Fanvura Marine';
    }
  }

  Widget _buildDrawerItem(int index, String title, IconData icon) {
    final isSel = _selectedNavIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSel ? FanvuraTheme.accent : FanvuraTheme.muted),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
          color: isSel ? FanvuraTheme.accent : FanvuraTheme.ink,
        ),
      ),
      selected: isSel,
      selectedTileColor: FanvuraTheme.edge.withValues(alpha: 0.3),
      onTap: () {
        setState(() => _selectedNavIndex = index);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildCurrentBody() {
    switch (_selectedNavIndex) {
      case 0: return _buildTideClockView();
      case 1: return _buildSwellForecastView();
      case 2: return _buildVoyageLogView();
      case 3: return _buildLunarGuideView();
      default: return _buildTideClockView();
    }
  }

  Widget _buildTideClockView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Wave chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Semi-Diurnal Sine Curve',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: FanvuraTheme.ink),
                      ),
                      Text(
                        '${_waterHeightM.toStringAsFixed(1)}m LAT',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: FanvuraTheme.accent, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 160,
                    child: CustomPaint(
                      painter: TideSineWavePainter(
                        tideProgress: _tideProgress,
                        currentHeightM: _waterHeightM,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('00:00 Low Tide (0.8m)', style: TextStyle(fontSize: 11, color: FanvuraTheme.muted)),
                      Text('06:12 High Tide (4.2m)', style: TextStyle(fontSize: 11, color: FanvuraTheme.accent, fontWeight: FontWeight.bold)),
                      Text('12:25 Low Tide (0.9m)', style: TextStyle(fontSize: 11, color: FanvuraTheme.muted)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tide scrubber
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Simulate Tidal Cycle Phase', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Slider(
                    value: _tideProgress,
                    min: 0.0,
                    max: 1.0,
                    activeColor: FanvuraTheme.accent,
                    inactiveColor: FanvuraTheme.edge,
                    onChanged: (v) {
                      setState(() {
                        _tideProgress = v;
                        _waterHeightM = 0.8 + (4.2 - 0.8) * ((1 - cos(v * 2 * 3.14159)) / 2);
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricBox('Phase Elapsed', '${(_tideProgress * 12.4).toStringAsFixed(1)} h'),
                      _buildMetricBox('Next Slack Water', '2h 15m'),
                      _buildMetricBox('Current Stream', '1.4 kts'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox(String label, String val) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FanvuraTheme.accent)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: FanvuraTheme.muted)),
      ],
    );
  }

  Widget _buildSwellForecastView() {
    final spots = [
      {'name': 'Outer Reef Shallows', 'height': '2.2 m', 'period': '14s', 'wind': '8 kts Off-shore', 'rating': 'Optimal'},
      {'name': 'North Headland Bay', 'height': '1.5 m', 'period': '11s', 'wind': '12 kts Cross', 'rating': 'Moderate'},
      {'name': 'Sandbar Lighthouse', 'height': '3.1 m', 'period': '16s', 'wind': '6 kts Glassy', 'rating': 'Epic'},
      {'name': 'Inlet Breakwater', 'height': '0.9 m', 'period': '9s', 'wind': '15 kts Choppy', 'rating': 'Poor'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: spots.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final s = spots[i];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(s['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: FanvuraTheme.edge,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(s['rating']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: FanvuraTheme.ink)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Swell: ${s['height']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: FanvuraTheme.accent)),
                    const SizedBox(width: 16),
                    Text('Period: ${s['period']}', style: const TextStyle(fontSize: 13, color: FanvuraTheme.muted)),
                    const Spacer(),
                    Text(s['wind']!, style: const TextStyle(fontSize: 12, color: FanvuraTheme.muted)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVoyageLogView() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _logs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final log = _logs[i];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: FanvuraTheme.edge,
              child: Icon(Icons.anchor_rounded, color: FanvuraTheme.accent),
            ),
            title: Text(log.location, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${log.condition} • Swell ${log.swellHeight}m'),
            trailing: Text(log.time, style: const TextStyle(fontSize: 12, color: FanvuraTheme.muted, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _buildLunarGuideView() {
    final phases = [
      {'name': 'Spring Tide (New Moon)', 'range': 'Maximum tidal range (high highs, low lows)', 'flow': 'Strong currents'},
      {'name': 'First Quarter Moon', 'range': 'Moderate tidal swing', 'flow': 'Standard slack intervals'},
      {'name': 'Neap Tide (Full Moon)', 'range': 'Lowest tidal range (dampened amplitude)', 'flow': 'Mild current stream'},
      {'name': 'Last Quarter Moon', 'range': 'Moderate transitioning swing', 'flow': 'Standard velocity'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: phases.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final p = phases[i];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.brightness_2_rounded, size: 20, color: FanvuraTheme.accent),
                    const SizedBox(width: 8),
                    Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(p['range']!, style: const TextStyle(fontSize: 13, color: FanvuraTheme.ink)),
                const SizedBox(height: 4),
                Text('Current Dynamic: ${p['flow']}', style: const TextStyle(fontSize: 12, color: FanvuraTheme.muted)),
              ],
            ),
          ),
        );
      },
    );
  }
}
