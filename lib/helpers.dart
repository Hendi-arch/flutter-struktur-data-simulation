import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

Future<void> openUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not open $url');
  }
}
