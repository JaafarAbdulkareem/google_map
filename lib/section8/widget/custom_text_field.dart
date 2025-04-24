import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.textEditingController,
  });
  final TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: TextField(
        // scrollPadding: EdgeInsets.all(0),
        controller: textEditingController,

        decoration: InputDecoration(
          // hintTextDirection: TextD,
          isDense: true,
          fillColor: Colors.white,
          filled: true,
          prefixIcon: const Icon(
            Icons.location_on_outlined,
            size: 25,
          ),
          hintText: "google search",
          hintStyle: const TextStyle(fontSize: 14),
          border: outlineInputBorder(),
          enabledBorder: outlineInputBorder(),
          focusedBorder: outlineInputBorder(),
        ),
      ),
    );
  }

  OutlineInputBorder outlineInputBorder() => OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
      );
}
