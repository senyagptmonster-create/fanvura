import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/fanvura_ocean_palette.dart';
import '../../core/marine_tide_controller.dart';

class MoonPhasesScreen extends StatelessWidget {
  const MoonPhasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MarineTideController>();
    final phaseName = controller.currentMoonPhaseName;
    final isSpring = controller.isSpringTide;
    final ratio = controller.lunarPhaseRatio;
    final illumination = (mathSinRatio(ratio) * 100).toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.nightlight_round, color: FanvuraOceanPalette.seafoamGreen, size: 24),
            SizedBox(width: 8),
            Text('Astronomical Moon & Tides'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Moon Phase Spotlight Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [FanvuraOceanPalette.deepTrench, FanvuraOceanPalette.marineSurface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSpring ? FanvuraOceanPalette.seafoamGreen.withValues(alpha: 0.5) : FanvuraOceanPalette.reefBorder,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CURRENT LUNAR CYCLE',
                            style: TextStyle(
                              fontFamily: 'AppFont',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                              color: FanvuraOceanPalette.saltMuted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            phaseName,
                            style: const TextStyle(
                              fontFamily: 'AppFont',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: FanvuraOceanPalette.foamWhite,
                            ),
                          ),
                          Text(
                            '$illumination% Illumination',
                            style: const TextStyle(
                              fontFamily: 'AppFont',
                              fontSize: 13,
                              color: FanvuraOceanPalette.cyanWave,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: FanvuraOceanPalette.abyssNavy,
                          boxShadow: [
                            BoxShadow(
                              color: FanvuraOceanPalette.seafoamGreen.withValues(alpha: 0.3),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            _getMoonIcon(phaseName),
                            size: 40,
                            color: FanvuraOceanPalette.foamWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSpring
                          ? FanvuraOceanPalette.seafoamGreen.withValues(alpha: 0.12)
                          : FanvuraOceanPalette.cyanWave.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSpring ? FanvuraOceanPalette.seafoamGreen : FanvuraOceanPalette.cyanWave,
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSpring ? Icons.flash_on : Icons.waves,
                          color: isSpring ? FanvuraOceanPalette.seafoamGreen : FanvuraOceanPalette.cyanWave,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isSpring
                                ? 'SPRING TIDES ACTIVE: Gravitational alignment causes highest high tides, lowest low tides, and maximum current speed.'
                                : 'NEAP TIDES ACTIVE: Sun and Moon at right angles produce minimal tidal range and moderate currents.',
                            style: const TextStyle(
                              fontFamily: 'AppFont',
                              fontSize: 12,
                              height: 1.3,
                              color: FanvuraOceanPalette.foamWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 14-Day Tidal Forecast List
            const Text(
              '14-Day Astronomical Lunar Almanac',
              style: TextStyle(
                fontFamily: 'AppFont',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: FanvuraOceanPalette.foamWhite,
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(14, (index) {
              final forecastDate = DateTime.now().add(Duration(days: index));
              final dayRatio = (ratio + (index / 29.530588)) % 1.0;
              final dayIsSpring = dayRatio < 0.12 || dayRatio > 0.88 || (dayRatio > 0.38 && dayRatio < 0.62);
              final dayIllumination = (mathSinRatio(dayRatio) * 100).toStringAsFixed(0);
              final tideRangeLabel = dayIsSpring ? 'Spring Tide (3.8m range)' : 'Neap Tide (1.9m range)';

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: FanvuraOceanPalette.deepTrench,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: dayIsSpring
                        ? FanvuraOceanPalette.seafoamGreen.withValues(alpha: 0.3)
                        : FanvuraOceanPalette.reefBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '${forecastDate.month}/${forecastDate.day}',
                      style: const TextStyle(
                        fontFamily: 'AppFont',
                        fontWeight: FontWeight.bold,
                        color: FanvuraOceanPalette.saltMuted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Icon(
                      dayIsSpring ? Icons.brightness_high : Icons.brightness_3,
                      color: dayIsSpring ? FanvuraOceanPalette.seafoamGreen : FanvuraOceanPalette.cyanWave,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tideRangeLabel,
                            style: TextStyle(
                              fontFamily: 'AppFont',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: dayIsSpring ? FanvuraOceanPalette.seafoamGreen : FanvuraOceanPalette.foamWhite,
                            ),
                          ),
                          Text(
                            '$dayIllumination% Lunar Light',
                            style: const TextStyle(
                              fontFamily: 'AppFont',
                              fontSize: 11,
                              color: FanvuraOceanPalette.saltMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: dayIsSpring
                            ? FanvuraOceanPalette.seafoamGreen.withValues(alpha: 0.15)
                            : FanvuraOceanPalette.marineSurface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dayIsSpring ? 'Peak Flow' : 'Mild Flow',
                        style: TextStyle(
                          fontFamily: 'AppFont',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: dayIsSpring ? FanvuraOceanPalette.seafoamGreen : FanvuraOceanPalette.saltMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  static double mathSinRatio(double ratio) {
    // 0 = new moon (0%), 0.5 = full moon (100%), 1.0 = new moon (0%)
    if (ratio <= 0.5) {
      return ratio * 2.0;
    } else {
      return (1.0 - ratio) * 2.0;
    }
  }

  IconData _getMoonIcon(String name) {
    if (name.contains('Full')) return Icons.brightness_1;
    if (name.contains('New')) return Icons.circle_outlined;
    if (name.contains('Quarter')) return Icons.brightness_medium;
    return Icons.brightness_3;
  }
}
