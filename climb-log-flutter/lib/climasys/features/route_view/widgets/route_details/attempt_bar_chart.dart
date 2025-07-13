import 'package:climasys/climasys/features/route_view/models/get_route_info_query_response.dart';
import 'package:flutter/material.dart';

class AttemptBarChart extends StatelessWidget {
  final List<AttemptCount> attempts;

  const AttemptBarChart({super.key, required this.attempts});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4.0,
      child: CustomPaint(
        painter: _MyBarChartPainter(
          attempts: attempts,
          barColor: Colors.blueAccent,
          textColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
        ),
      ),
    );
  }
}

class _MyBarChartPainter extends CustomPainter {
  final List<AttemptCount> attempts;
  final Color barColor;
  final Color textColor;

  static const _bucketKeys = [1, 2, 3, 4, 5];

  _MyBarChartPainter({
    required this.attempts,
    required this.barColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final attemptMap = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final a in attempts) {
      if (a.attemptNumber >= 5) {
        attemptMap[5] = attemptMap[5]! + a.count;
      } else {
        attemptMap[a.attemptNumber] = attemptMap[a.attemptNumber]! + a.count;
      }
    }

    final rawMax = attemptMap.values.fold(0, (prev, c) => c > prev ? c : prev);
    final maxCount = (rawMax < 1) ? 1.0 : rawMax.toDouble();

    const barWidth = 30.0;
    const barSpacing = 20.0;
    const topMargin = 16.0;
    const bottomMargin = 16.0;
    const labelOffsetAboveBar = 4;

    final chartTop = topMargin;
    final chartBottom = size.height - bottomMargin;
    final chartHeight = chartBottom - chartTop;

    final numBars = _bucketKeys.length; // = 5
    final numTicks = numBars + 1;       // = 6

    final regionWidth = barWidth + barSpacing;
    final totalWidth = regionWidth * numBars;
    final axisLeft = (size.width - totalWidth) / 2;
    final axisRight = axisLeft + totalWidth;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    final textStyle = TextStyle(
      color: textColor,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    String labelForKey(int k) {
      switch (k) {
        case 1:
          return 'Flash';
        case 5:
          return '5+';
        default:
          return '$k';
      }
    }

    for (int i = 0; i < numBars; i++) {
      final key = _bucketKeys[i];
      final count = attemptMap[key]!.toDouble();

      final barCenter = axisLeft + (i + 0.5) * regionWidth;
      final barLeft = barCenter - (barWidth * 0.5);

      final fraction = count / maxCount;
      final barHeight = chartHeight * fraction;
      final barTop = chartBottom - barHeight;

      if (count > 0) {
        final paintBar = Paint()..color = barColor;
        final barRect = Rect.fromLTWH(barLeft, barTop, barWidth, barHeight);
        canvas.drawRRect(
          RRect.fromRectAndRadius(barRect, const Radius.circular(4)),
          paintBar,
        );

        final barLabel = count.toInt().toString();
        textPainter.text = TextSpan(text: barLabel, style: textStyle);
        textPainter.layout(minWidth: 0, maxWidth: barWidth);
        final labelX = barCenter - (textPainter.width / 2);
        final labelY = barTop - textPainter.height - labelOffsetAboveBar;
        textPainter.paint(canvas, Offset(labelX, labelY));
      }

      final bottomLabel = labelForKey(key);
      textPainter.text = TextSpan(text: bottomLabel, style: textStyle);
      textPainter.layout(minWidth: 0, maxWidth: regionWidth);
      final bottomLabelX = barCenter - (textPainter.width / 2);
      final bottomLabelY = chartBottom + 6; // a little gap below axis
      textPainter.paint(canvas, Offset(bottomLabelX, bottomLabelY));
    }

    final axisPaint = Paint()
      ..color = textColor
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(axisLeft, chartBottom),
      Offset(axisRight, chartBottom),
      axisPaint,
    );

    for (int i = 0; i < numTicks; i++) {
      final tickX = axisLeft + i * regionWidth;
      const tickHeight = 4.0;
      canvas.drawLine(
        Offset(tickX, chartBottom),
        Offset(tickX, chartBottom - tickHeight),
        axisPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MyBarChartPainter oldDelegate) {
    return oldDelegate.attempts != attempts ||
        oldDelegate.barColor != barColor ||
        oldDelegate.textColor != textColor;
  }
}
