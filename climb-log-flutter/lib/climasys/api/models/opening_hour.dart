import 'package:flutter/material.dart';

class OpeningHour {
  final int dayNumber;
  final String weekDay;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  OpeningHour({
    required this.dayNumber,
    required this.weekDay,
    required this.startTime,
    required this.endTime,
  });

  factory OpeningHour.fromJson(Map<String, dynamic> json) {
    // Assuming the time is in the format "HH:MM:SS"
    final startParts = json['startTime'].split(':'); // ["10", "00", "00"]
    final endParts = json['endTime'].split(':'); // ["22", "00", "00"]

    final startTime = TimeOfDay(
      hour: int.parse(startParts[0]),
      minute: int.parse(startParts[1]),
    );

    final endTime = TimeOfDay(
      hour: int.parse(endParts[0]),
      minute: int.parse(endParts[1]),
    );

    return OpeningHour(
      dayNumber: json['dayNumber'],
      weekDay: json['weekDay'],
      startTime: startTime,
      endTime: endTime,
    );
  }

  Map<String, dynamic> toJson() => {
    'dayNumber': dayNumber,
    'weekDay': weekDay,
    'startTime': '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}:00',
    'endTime': '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}:00'
  };
}
