import 'package:flutter/material.dart';
import 'package:google_map/section3/widget/custom_google_map.dart';

class Section3 extends StatelessWidget {
  const Section3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: CustomGoogleMap(),
      ),
    );
  }
}
