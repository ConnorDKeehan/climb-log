import 'package:flutter/material.dart';

import 'facility.dart';
import 'opening_hour.dart';

// Main model returned by the API
class GymAboutDetails {
  final String gymName;
  final String? address;
  final bool? currentlyOpen;
  final TimeOfDay? todayStartTime;
  final TimeOfDay? todayEndTime;
  final List<OpeningHour> openingHours;
  final List<Facility> facilities;

  GymAboutDetails({
    required this.gymName,
    required this.address,
    required this.currentlyOpen,
    required this.todayStartTime,
    required this.todayEndTime,
    required this.openingHours,
    required this.facilities,
  });

  factory GymAboutDetails.fromJson(Map<String, dynamic> json) {
    final startParts = json['todayStartTime']?.split(':'); // ["10", "00", "00"]
    final endParts = json['todayEndTime']?.split(':'); // ["22", "00", "00"]


    final startTime = startParts != null ? TimeOfDay(
      hour: int.parse(startParts[0]),
      minute: int.parse(startParts[1]),
    ) : null;

    final endTime = endParts != null ? TimeOfDay(
      hour: int.parse(endParts[0]),
      minute: int.parse(endParts[1]),
    ) : null;

    return GymAboutDetails(
      gymName: json['gymName'],
      address: json['address'],
      currentlyOpen: json['currentlyOpen'],
      todayStartTime: startTime,
      todayEndTime: endTime,

      openingHours: (json['openingHours'] as List<dynamic>)
          .map((item) => OpeningHour.fromJson(item))
          .toList(),
      facilities: (json['facilities'] as List<dynamic>)
          .map((item) => Facility.fromJson(item))
          .toList(),


    );
  }

  Map<String, dynamic> toJson() => {
    'gymName': gymName,
    'address': address,
    'openingHours': openingHours.map((oh) => oh.toJson()).toList(),
    'facilities': facilities.map((f) => f.toJson()).toList(),
  };
}