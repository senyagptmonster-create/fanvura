import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/tide_data_service.dart';
import '../../core/marine_theme.dart';

class CoastalLogScreen extends StatefulWidget {
  const CoastalLogScreen({super.key});

  @override
  State<CoastalLogScreen> createState() => _CoastalLogScreenState();
}

class _CoastalLogScreenState extends State<CoastalLogScreen> {
  final _locationCtrl = TextEditingController();
  final _conditionCtrl = TextEditingController();

  void _addLog() {
    if (_locationCtrl.text.isNotEmpty) {
      context.read<TideDataService>().addLog(
            _locationCtrl.text,
            _conditionCtrl.text.isEmpty ? 'Calm' : _conditionCtrl.text,
            1.8,
          );
      _locationCtrl.clear();
      _conditionCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coastal observation recorded!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<TideDataService>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MarineTheme.surfaceCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Log Coastal Session', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                TextField(
                  controller: _locationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Break / Beach Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _conditionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Observations (Wind, current, visibility)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addLog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MarineTheme.reefTeal,
                      foregroundColor: MarineTheme.deepAbyss,
                    ),
                    child: const Text('Save Log'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Session Archives', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...service.logs.map((log) => Card(
                color: MarineTheme.surfaceCard,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(log.location, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(log.condition, style: const TextStyle(color: Colors.white70)),
                  trailing: Text('${log.waveHeightM}m',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: MarineTheme.reefTeal)),
                ),
              )),
        ],
      ),
    );
  }
}
