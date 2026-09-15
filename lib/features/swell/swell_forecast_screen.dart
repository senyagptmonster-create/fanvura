import 'package:flutter/material.dart';
import '../../core/marine_theme.dart';

class SwellForecastScreen extends StatelessWidget {
  const SwellForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final forecasts = [
      {'time': '06:00 AM', 'height': '1.8m', 'period': '13s', 'dir': 'WNW 290°', 'rating': 'Clean'},
      {'time': '10:00 AM', 'height': '2.1m', 'period': '14s', 'dir': 'WNW 295°', 'rating': 'Epic'},
      {'time': '02:00 PM', 'height': '1.9m', 'period': '12s', 'dir': 'W 275°', 'rating': 'Fair (Onshore)'},
      {'time': '06:00 PM', 'height': '2.3m', 'period': '15s', 'dir': 'NW 310°', 'rating': 'Heavy Swell'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: forecasts.length,
      itemBuilder: (context, idx) {
        final f = forecasts[idx];
        return Card(
          color: MarineTheme.surfaceCard,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f['time']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('${f['dir']} • ${f['rating']}',
                          style: const TextStyle(color: MarineTheme.seafoam, fontSize: 13)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(f['height']!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: MarineTheme.reefTeal,
                        )),
                    Text(f['period']!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
