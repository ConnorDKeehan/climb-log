import 'package:flutter/material.dart';

class SectorDisplay extends StatelessWidget {
  final String sectorName;
  final int ascendedCount;
  final int totalCount;
  final double currentZoom; // changed to double for convenience

  const SectorDisplay({
    super.key,
    required this.sectorName,
    required this.ascendedCount,
    required this.totalCount,
    required this.currentZoom,
  });

  @override
  Widget build(BuildContext context) {
    // Avoid dividing by zero if currentZoom is ever 0 or extremely small
    final double scaleFactor = currentZoom <= 0.0001 ? 1.0 : (1.0 / currentZoom);

    return Transform.scale(
      scale: scaleFactor,
      // Optionally adjust alignment so it scales around the top-center or bottom-center, etc.
      // alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1) The top pill
          Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              '$ascendedCount / $totalCount',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 2) Slight overlap
          Transform.translate(
            offset: const Offset(0, -6), // negative offset for overlap
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                sectorName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
