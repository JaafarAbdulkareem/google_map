import 'package:flutter/material.dart';
import 'package:google_map/section2/widget/custom_google_map.dart';

class Section2 extends StatelessWidget {
  const Section2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: CustomGoogleMap(),
      ),
    );
  }
}
