import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:struktur_data_demo/helpers.dart';

class SourceCodeWidget extends StatelessWidget {
  const SourceCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: IconButton.filledTonal(
        onPressed: () => openUrl(
            'https://github.com/Hendi-arch/flutter-struktur-data-simulation'),
        icon: const FaIcon(FontAwesomeIcons.github),
      ),
    );
  }
}
