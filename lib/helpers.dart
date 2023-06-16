import 'dart:math';

import 'package:flutter/material.dart';

Future<void> scrollTo(ScrollController scrollController, double offset) async {
  scrollController.animateTo(
    offset,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );
}

Color getRandomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }
