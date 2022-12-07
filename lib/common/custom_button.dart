import 'package:flutter/material.dart';

import '../colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const CustomButton({Key? key, required this.text, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: tabColor,
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: callback,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: blackColor,
        ),
      ),
    );
  }
}
