import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/marine_theme.dart';
import 'core/tide_data_service.dart';
import 'features/tide_clock/tide_clock_screen.dart';
import 'features/swell/swell_forecast_screen.dart';
import 'features/log/coastal_log_screen.dart';
import 'features/moon/moon_phase_screen.dart';

class FanvuraApp extends StatelessWidget {
  const FanvuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TideDataService(),
      child: MaterialApp(
        title: 'Fanvura Ocean Tides',
        theme: MarineTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const FanvuraHomeScaffold(),
      ),
    );
  }
}

class FanvuraHomeScaffold extends StatefulWidget {
  const FanvuraHomeScaffold({super.key});

  @override
  State<FanvuraHomeScaffold> createState() => _FanvuraHomeScaffoldState();
}

class _FanvuraHomeScaffoldState extends State<FanvuraHomeScaffold> {
  int _currentIndex = 0;

  final _titles = ['Tide Clock', 'Swell Forecast', 'Coastal Log', 'Lunar Phase'];
  final _screens = const [
    TideClockScreen(),
    SwellForecastScreen(),
    CoastalLogScreen(),
    MoonPhaseScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.waves_outlined), selectedIcon: Icon(Icons.waves), label: 'Tide'),
          NavigationDestination(icon: Icon(Icons.surfing_outlined), selectedIcon: Icon(Icons.surfing), label: 'Swell'),
          NavigationDestination(icon: Icon(Icons.book_outlined), selectedIcon: Icon(Icons.book), label: 'Log'),
          NavigationDestination(icon: Icon(Icons.brightness_3_outlined), selectedIcon: Icon(Icons.brightness_3), label: 'Moon'),
        ],
      ),
    );
  }
}
