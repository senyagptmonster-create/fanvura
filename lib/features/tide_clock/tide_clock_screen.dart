import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/tide_data_service.dart';
import '../../core/marine_theme.dart';

class TideClockScreen extends StatelessWidget {
  const TideClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<TideDataService>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: MarineTheme.surfaceCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: MarineTheme.reefTeal),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(service.selectedStation,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          // Circular tide clock
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MarineTheme.surfaceCard,
              border: Border.all(color: MarineTheme.reefTeal, width: 4),
              boxShadow: [
                BoxShadow(
                  color: MarineTheme.reefTeal.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  service.isRising ? Icons.arrow_upward : Icons.arrow_downward,
                  color: service.isRising ? MarineTheme.reefTeal : MarineTheme.coralOrange,
                  size: 32,
                ),
                const SizedBox(height: 4),
                Text('${service.currentTideMeters.toStringAsFixed(2)} m',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    )),
                Text(service.isRising ? 'FLOOD / RISING' : 'EBB / FALLING',
                    style: const TextStyle(
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: MarineTheme.seafoam,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MarineTheme.surfaceCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Next High Slack Tide', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text('In ${service.nextSlackMinutes} minutes',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: MarineTheme.reefTeal)),
                    ],
                  ),
                ),
                const Icon(Icons.timer, color: MarineTheme.reefTeal, size: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
