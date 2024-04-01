import 'package:flutter/material.dart';

class MInfoCard {
  final String title;
  final String value;
  final IconData icon;

  MInfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  factory MInfoCard.fromMap(Map<String, dynamic> map) {
    return MInfoCard(
      title: map['title'],
      value: map['value'],
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'value': value,
      'icon': icon.codePoint,
    };
  }
}
