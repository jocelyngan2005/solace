import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodChart extends StatelessWidget {
  const MoodChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[300],
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                );
                switch (value.toInt()) {
                  case 0:
                    return const Text('Mon', style: style);
                  case 1:
                    return const Text('Tue', style: style);
                  case 2:
                    return const Text('Wed', style: style);
                  case 3:
                    return const Text('Thu', style: style);
                  case 4:
                    return const Text('Fri', style: style);
                  case 5:
                    return const Text('Sat', style: style);
                  case 6:
                    return const Text('Sun', style: style);
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                );
                switch (value.toInt()) {
                  case 1:
                    return const Text('😔', style: style);
                  case 2:
                    return const Text('😐', style: style);
                  case 3:
                    return const Text('🙂', style: style);
                  case 4:
                    return const Text('😊', style: style);
                  case 5:
                    return const Text('😄', style: style);
                  default:
                    return const Text('');
                }
              },
              reservedSize: 28,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        minX: 0,
        maxX: 6,
        minY: 1,
        maxY: 5,
        lineBarsData: [
          LineChartBarData(
            spots: _getMoodData(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: Color(0xFFFEFEFE),
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getMoodData() {
    // Dummy mood data for the week
    return const [
      FlSpot(0, 4), // Monday - Good
      FlSpot(1, 3), // Tuesday - Okay
      FlSpot(2, 2), // Wednesday - Low
      FlSpot(3, 2.5), // Thursday - Slightly better
      FlSpot(4, 3.5), // Friday - Better
      FlSpot(5, 4.5), // Saturday - Great
      FlSpot(6, 4), // Sunday - Good
    ];
  }
}
