
import 'package:expenses_tracker/widgets/expences_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashServices {
  void islogin(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Expenses(),
          ),
        );
      },
    );
  }
}
