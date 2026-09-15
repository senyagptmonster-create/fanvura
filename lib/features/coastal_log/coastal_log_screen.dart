import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/fanvura_ocean_palette.dart';
import '../../core/marine_tide_controller.dart';

class CoastalLogScreen extends StatelessWidget {
  const CoastalLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MarineTideController>();
    final logs = controller.logs;

    final avgTemp = logs.isEmpty
        ? 0.0
        : logs.map((e) => e.waterTempC).reduce((a, b) => a + b) / logs.length;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.book, color: FanvuraOceanPalette.seafoamGreen, size: 24),
            SizedBox(width: 8),
            Text('Coastal Session Journal'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: FanvuraOceanPalette.seafoamGreen,
        foregroundColor: FanvuraOceanPalette.abyssNavy,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text(
          'Log Session',
          style: TextStyle(fontFamily: 'AppFont', fontWeight: FontWeight.bold),
        ),
        onPressed: () => _showAddSessionSheet(context),
      ),
      body: CustomScrollView(
        slivers: [
          // Header Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatBadge(
                      label: 'Total Sessions',
                      value: '${logs.length}',
                      icon: Icons.surfing,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatBadge(
                      label: 'Avg Water Temp',
                      value: logs.isEmpty ? '--' : '${avgTemp.toStringAsFixed(1)}°C',
                      icon: Icons.thermostat,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Session list
          if (logs.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'No sessions recorded yet.\nTap below to log your coastal expedition.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    color: FanvuraOceanPalette.saltMuted,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final log = logs[index];
                    return _buildLogCard(context, log, controller);
                  },
                  childCount: logs.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildStatBadge({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FanvuraOceanPalette.deepTrench,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: FanvuraOceanPalette.reefBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: FanvuraOceanPalette.seafoamGreen, size: 24),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'AppFont',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: FanvuraOceanPalette.foamWhite,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'AppFont',
              fontSize: 12,
              color: FanvuraOceanPalette.saltMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(
    BuildContext context,
    CoastalLogEntry log,
    MarineTideController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: FanvuraOceanPalette.deepTrench,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FanvuraOceanPalette.reefBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  log.breakLocation,
                  style: const TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: FanvuraOceanPalette.seafoamGreen,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: FanvuraOceanPalette.saltMuted),
                onPressed: () => controller.removeLog(log.id),
              ),
            ],
          ),
          Text(
            '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontFamily: 'AppFont',
              fontSize: 12,
              color: FanvuraOceanPalette.saltMuted,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildPill(Icons.thermostat, '${log.waterTempC.toStringAsFixed(1)}°C'),
              const SizedBox(width: 8),
              _buildPill(Icons.air, '${log.windSpeedKnots.toStringAsFixed(0)} kts'),
              const SizedBox(width: 8),
              _buildPill(Icons.waves, '${log.waveHeightMeters.toStringAsFixed(1)} m'),
            ],
          ),
          if (log.notes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              log.notes,
              style: const TextStyle(
                fontFamily: 'AppFont',
                fontSize: 13,
                color: FanvuraOceanPalette.foamWhite,
                height: 1.3,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < log.rating ? Icons.star : Icons.star_border,
                size: 18,
                color: FanvuraOceanPalette.amberWarning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: FanvuraOceanPalette.marineSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: FanvuraOceanPalette.cyanWave),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'AppFont',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: FanvuraOceanPalette.foamWhite,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSessionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: FanvuraOceanPalette.deepTrench,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const _AddSessionSheet(),
    );
  }
}

class _AddSessionSheet extends StatefulWidget {
  const _AddSessionSheet();

  @override
  State<_AddSessionSheet> createState() => _AddSessionSheetState();
}

class _AddSessionSheetState extends State<_AddSessionSheet> {
  final _locationController = TextEditingController(text: 'Hossegor La Gravière');
  final _notesController = TextEditingController();
  double _waterTemp = 19.0;
  double _windSpeed = 12.0;
  double _waveHeight = 1.8;
  int _rating = 4;

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Log Coastal Session',
              style: TextStyle(
                fontFamily: 'AppFont',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: FanvuraOceanPalette.foamWhite,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Break / Spot Location',
                prefixIcon: Icon(Icons.location_pin, color: FanvuraOceanPalette.cyanWave),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Water Temperature', style: TextStyle(fontFamily: 'AppFont', color: FanvuraOceanPalette.saltMuted)),
                Text('${_waterTemp.toStringAsFixed(1)}°C', style: const TextStyle(fontFamily: 'AppFont', fontWeight: FontWeight.bold, color: FanvuraOceanPalette.seafoamGreen)),
              ],
            ),
            Slider(
              value: _waterTemp,
              min: 8.0,
              max: 30.0,
              divisions: 44,
              activeColor: FanvuraOceanPalette.seafoamGreen,
              onChanged: (v) => setState(() => _waterTemp = v),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Wind Speed', style: TextStyle(fontFamily: 'AppFont', color: FanvuraOceanPalette.saltMuted)),
                Text('${_windSpeed.toStringAsFixed(0)} kts', style: const TextStyle(fontFamily: 'AppFont', fontWeight: FontWeight.bold, color: FanvuraOceanPalette.cyanWave)),
              ],
            ),
            Slider(
              value: _windSpeed,
              min: 0.0,
              max: 40.0,
              divisions: 40,
              activeColor: FanvuraOceanPalette.cyanWave,
              onChanged: (v) => setState(() => _windSpeed = v),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Wave Height', style: TextStyle(fontFamily: 'AppFont', color: FanvuraOceanPalette.saltMuted)),
                Text('${_waveHeight.toStringAsFixed(1)} m', style: const TextStyle(fontFamily: 'AppFont', fontWeight: FontWeight.bold, color: FanvuraOceanPalette.seafoamGreen)),
              ],
            ),
            Slider(
              value: _waveHeight,
              min: 0.5,
              max: 5.0,
              divisions: 45,
              activeColor: FanvuraOceanPalette.seafoamGreen,
              onChanged: (v) => setState(() => _waveHeight = v),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Session Rating', style: TextStyle(fontFamily: 'AppFont', color: FanvuraOceanPalette.saltMuted)),
                Row(
                  children: List.generate(
                    5,
                    (index) => IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: FanvuraOceanPalette.amberWarning,
                      ),
                      onPressed: () => setState(() => _rating = index + 1),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Session Notes / Gear Used',
                prefixIcon: Icon(Icons.edit_note, color: FanvuraOceanPalette.cyanWave),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Save Expedition Entry'),
              onPressed: () {
                final loc = _locationController.text.trim();
                if (loc.isEmpty) return;
                final entry = CoastalLogEntry(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  date: DateTime.now(),
                  breakLocation: loc,
                  waterTempC: _waterTemp,
                  windSpeedKnots: _windSpeed,
                  waveHeightMeters: _waveHeight,
                  rating: _rating,
                  notes: _notesController.text.trim(),
                );
                context.read<MarineTideController>().addLog(entry);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
