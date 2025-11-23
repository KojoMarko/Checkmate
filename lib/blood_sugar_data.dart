import 'package:flutter/foundation.dart';
import 'dart:math';

class BloodSugarReading {
  final double value;
  final ReadingType type;
  final DateTime timestamp;

  BloodSugarReading({required this.value, required this.type, required this.timestamp});

  String get typeAsString {
    switch (type) {
      case ReadingType.fasting:
        return 'Fasting';
      case ReadingType.beforeMeal:
        return 'Before Meal';
      case ReadingType.afterMeal:
        return 'After Meal';
      default:
        return 'General';
    }
  }

  String get level {
    if (value > 180) return 'High';
    if (value < 70) return 'Low';
    return 'Normal';
  }
}

enum ReadingType { fasting, beforeMeal, afterMeal, general }

class BloodSugarData extends ChangeNotifier {
  final List<BloodSugarReading> _readings = [];

  BloodSugarData() {
    // Generate some random initial data
    final random = Random();
    for (int i = 0; i < 15; i++) {
      _readings.add(
        BloodSugarReading(
          value: 80 + random.nextDouble() * 100,
          type: ReadingType.values[random.nextInt(ReadingType.values.length)],
          timestamp: DateTime.now().subtract(Duration(hours: i * 3)),
        ),
      );
    }
    _readings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<BloodSugarReading> get readings => _readings;

  BloodSugarReading get latestReading => _readings.first;

  double get averageReading {
    if (_readings.isEmpty) return 0;
    return _readings.take(5).map((r) => r.value).reduce((a, b) => a + b) / 5;
  }

  double get lowestReading {
    if (_readings.isEmpty) return 0;
    return _readings.map((r) => r.value).reduce(min);
  }

  double get highestReading {
    if (_readings.isEmpty) return 0;
    return _readings.map((r) => r.value).reduce(max);
  }

  void addReading(BloodSugarReading reading) {
    _readings.insert(0, reading);
    notifyListeners();
  }
}
