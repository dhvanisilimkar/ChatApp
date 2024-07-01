import 'dart:async';
import 'package:fb_chat_app/helper/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utils/colors.dart';
import '../../utils/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        Navigator.of(context).pushReplacementNamed(
          (AuthHepler.authHepler.firebaseAuth.currentUser != null)
              ? MyRoutes.home
              : MyRoutes.lets,
        );
        timer.cancel();
      },
    );
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo/logo4.png', scale: 4.5),
            Gap(20),
            Text(
              "Talk Hub",
              style: TextStyle(
                  fontSize: 30, color: darkBlue, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
