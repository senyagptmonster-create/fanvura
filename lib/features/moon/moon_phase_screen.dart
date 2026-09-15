import 'package:flutter/material.dart';
import '../../core/marine_theme.dart';

class MoonPhaseScreen extends StatelessWidget {
  const MoonPhaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: MarineTheme.surfaceCard,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(Icons.nightlight_round, size: 48, color: Colors.amberAccent),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Waxing Gibbous (88%)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 4),
                      Text('Approaching Spring Tide: Expect higher highs and lower low tides.',
                          style: TextStyle(color: MarineTheme.seafoam, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Tidal Physics Reference', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _TidalGuideCard(
            title: 'Spring Tides (Highest Range)',
            desc: 'Occurs during New and Full moons when Sun, Moon, and Earth align in syzygy. Gravitational forces multiply.',
          ),
          const SizedBox(height: 8),
          _TidalGuideCard(
            title: 'Neap Tides (Moderate Range)',
            desc: 'Occurs during First and Third quarter moons. Gravitational vectors offset at right angles, resulting in weak tidal flux.',
          ),
          const SizedBox(height: 8),
          _TidalGuideCard(
            title: 'Semi-diurnal Cycles',
            desc: 'Most coastlines experience two nearly equal high tides and two low tides each lunar day of 24h 50m.',
          ),
        ],
      ),
    );
  }
}

class _TidalGuideCard extends StatelessWidget {
  final String title;
  final String desc;

  const _TidalGuideCard({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MarineTheme.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: MarineTheme.reefTeal)),
            const SizedBox(height: 6),
            Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
