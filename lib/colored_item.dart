import 'package:flutter/material.dart';

class ColoredItem {
  final Color color;
  final String value;
  final int? index;
  bool isFlat;
  double height;

  ColoredItem.stack({
    required this.color,
    required this.value,
  })  : index = null,
        isFlat = true,
        height = 45;

  ColoredItem.queue({
    required this.color,
    required this.value,
    required this.index,
  })  : isFlat = true,
        height = 45;
}
