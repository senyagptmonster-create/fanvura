import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/fanvura_ocean_palette.dart';
import '../../core/marine_tide_controller.dart';

class SwellConditionScreen extends StatelessWidget {
  const SwellConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MarineTideController>();

    Color gradeColor;
    if (controller.surfGrade.startsWith('Grade S') || controller.surfGrade.startsWith('Grade A')) {
      gradeColor = FanvuraOceanPalette.seafoamGreen;
    } else if (controller.surfGrade.startsWith('Grade B')) {
      gradeColor = FanvuraOceanPalette.cyanWave;
    } else if (controller.surfGrade.startsWith('Grade C')) {
      gradeColor = FanvuraOceanPalette.amberWarning;
    } else {
      gradeColor = FanvuraOceanPalette.coralAlert;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.waves, color: FanvuraOceanPalette.seafoamGreen, size: 24),
            SizedBox(width: 8),
            Text('Swell & Safety Grade'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Surf Grade Banner Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: FanvuraOceanPalette.deepTrench,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: gradeColor.withValues(alpha: 0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: gradeColor.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'CALCULATED SURF SAFETY',
                        style: TextStyle(
                          fontFamily: 'AppFont',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: FanvuraOceanPalette.saltMuted,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: gradeColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          controller.windDirection,
                          style: TextStyle(
                            fontFamily: 'AppFont',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: gradeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.surfGrade,
                    style: TextStyle(
                      fontFamily: 'AppFont',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: gradeColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Recommended Quiver: ${controller.recommendedBoard}',
                    style: const TextStyle(
                      fontFamily: 'AppFont',
                      fontSize: 13,
                      color: FanvuraOceanPalette.foamWhite,
                    ),
                  ),
                  const Divider(color: FanvuraOceanPalette.reefBorder, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricItem(
                        'Total Energy',
                        '${controller.energyKilojoules.toStringAsFixed(1)} kJ',
                        Icons.bolt,
                      ),
                      _buildMetricItem(
                        'Rip Risk',
                        controller.waveHeight > 2.5 ? 'Severe' : (controller.waveHeight > 1.5 ? 'Moderate' : 'Low'),
                        Icons.warning_amber_rounded,
                      ),
                      _buildMetricItem(
                        'Power Ratio',
                        '${(controller.swellPeriod * controller.waveHeight / 10).toStringAsFixed(1)}x',
                        Icons.speed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Preset Chips
            const Text(
              'Scenario Presets',
              style: TextStyle(
                fontFamily: 'AppFont',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: FanvuraOceanPalette.saltMuted,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPresetChip(
                    label: 'Glassy Peeler',
                    onTap: () => controller.updateSwellConditions(
                      waveHeight: 1.5,
                      swellPeriod: 14.0,
                      windSpeed: 6.0,
                      windDirection: 'Offshore',
                    ),
                  ),
                  _buildPresetChip(
                    label: 'Winter Bomb',
                    onTap: () => controller.updateSwellConditions(
                      waveHeight: 4.2,
                      swellPeriod: 18.0,
                      windSpeed: 14.0,
                      windDirection: 'Offshore',
                    ),
                  ),
                  _buildPresetChip(
                    label: 'Choppy Onshore',
                    onTap: () => controller.updateSwellConditions(
                      waveHeight: 2.2,
                      swellPeriod: 8.0,
                      windSpeed: 24.0,
                      windDirection: 'Onshore',
                    ),
                  ),
                  _buildPresetChip(
                    label: 'Mellow Cruiser',
                    onTap: () => controller.updateSwellConditions(
                      waveHeight: 0.9,
                      swellPeriod: 11.0,
                      windSpeed: 8.0,
                      windDirection: 'Cross-shore',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Interactive Sliders
            _buildSliderControl(
              title: 'Wave Face Height',
              valueText: controller.useMetric
                  ? '${controller.waveHeight.toStringAsFixed(1)} m'
                  : '${(controller.waveHeight * 3.28084).toStringAsFixed(1)} ft',
              value: controller.waveHeight,
              min: 0.5,
              max: 6.0,
              divisions: 55,
              onChanged: (val) => controller.updateSwellConditions(waveHeight: val),
            ),
            const SizedBox(height: 16),
            _buildSliderControl(
              title: 'Swell Period',
              valueText: '${controller.swellPeriod.toStringAsFixed(1)} seconds',
              value: controller.swellPeriod,
              min: 5.0,
              max: 22.0,
              divisions: 34,
              onChanged: (val) => controller.updateSwellConditions(swellPeriod: val),
            ),
            const SizedBox(height: 16),
            _buildSliderControl(
              title: 'Wind Speed',
              valueText: '${controller.windSpeed.toStringAsFixed(0)} knots',
              value: controller.windSpeed,
              min: 0.0,
              max: 45.0,
              divisions: 45,
              onChanged: (val) => controller.updateSwellConditions(windSpeed: val),
            ),
            const SizedBox(height: 20),

            // Wind Direction Selector
            const Text(
              'Wind Angle & Direction',
              style: TextStyle(
                fontFamily: 'AppFont',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: FanvuraOceanPalette.foamWhite,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Offshore', label: Text('Offshore')),
                ButtonSegment(value: 'Cross-shore', label: Text('Cross-shore')),
                ButtonSegment(value: 'Onshore', label: Text('Onshore')),
              ],
              selected: {controller.windDirection},
              onSelectionChanged: (newSelection) {
                controller.updateSwellConditions(windDirection: newSelection.first);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return FanvuraOceanPalette.seafoamGreen;
                  }
                  return FanvuraOceanPalette.marineSurface;
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return FanvuraOceanPalette.abyssNavy;
                  }
                  return FanvuraOceanPalette.foamWhite;
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip({required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(label),
        backgroundColor: FanvuraOceanPalette.deepTrench,
        side: const BorderSide(color: FanvuraOceanPalette.reefBorder),
        labelStyle: const TextStyle(
          fontFamily: 'AppFont',
          color: FanvuraOceanPalette.seafoamGreen,
          fontSize: 12,
        ),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: FanvuraOceanPalette.cyanWave, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'AppFont',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: FanvuraOceanPalette.foamWhite,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'AppFont',
            fontSize: 11,
            color: FanvuraOceanPalette.saltMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildSliderControl({
    required String title,
    required String valueText,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'AppFont',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: FanvuraOceanPalette.foamWhite,
                ),
              ),
              Text(
                valueText,
                style: const TextStyle(
                  fontFamily: 'AppFont',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: FanvuraOceanPalette.seafoamGreen,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: FanvuraOceanPalette.seafoamGreen,
            inactiveColor: FanvuraOceanPalette.marineSurface,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
