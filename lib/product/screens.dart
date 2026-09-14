import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/theme.dart';
import 'fanvura_store.dart';

class FanvuraHome extends StatefulWidget {
  const FanvuraHome({super.key});
  @override
  _FanvuraHomeState createState() => _FanvuraHomeState();
}

class _FanvuraHomeState extends State<FanvuraHome> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const TideClockScreen(),
    const SwellConditionScreen(),
    const CoastalLogScreen(),
    const MoonPhaseScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fanvura', style: AppTheme.display(context))),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(title: Text('Tide Clock', style: AppTheme.text(context)), onTap: () { setState(() { _currentIndex = 0; Navigator.pop(context); }); }),
            ListTile(title: Text('Swell Condition', style: AppTheme.text(context)), onTap: () { setState(() { _currentIndex = 1; Navigator.pop(context); }); }),
            ListTile(title: Text('Coastal Log', style: AppTheme.text(context)), onTap: () { setState(() { _currentIndex = 2; Navigator.pop(context); }); }),
            ListTile(title: Text('Moon Phase', style: AppTheme.text(context)), onTap: () { setState(() { _currentIndex = 3; Navigator.pop(context); }); }),
          ],
        ),
      ),
      body: _screens[_currentIndex],
    );
  }
}

class TideClockScreen extends StatelessWidget {
  const TideClockScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text('Tide Clock Visualizer', style: AppTheme.display(context)));
}

class SwellConditionScreen extends StatelessWidget {
  const SwellConditionScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text('Swell Condition Rating', style: AppTheme.display(context)));
}

class CoastalLogScreen extends StatelessWidget {
  const CoastalLogScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final store = context.watch<FanvuraStore>();
    return ListView.builder(
      itemCount: store.logs.length,
      itemBuilder: (context, index) {
        final log = store.logs[index];
        return ListTile(
          title: Text(log['title'], style: AppTheme.text(context)),
          subtitle: Text(log['condition'], style: AppTheme.text(context)),
        );
      },
    );
  }
}

class MoonPhaseScreen extends StatelessWidget {
  const MoonPhaseScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text('Moon Phase Guide', style: AppTheme.display(context)));
}
