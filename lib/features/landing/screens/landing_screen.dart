import 'package:flutter/material.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/custom_button.dart';
import 'package:whatsapp_ui/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = '/landing-screen';

  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Welcome to WhatsApp',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 33.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: size.height / 9,
            ),
            Image.asset(
              'assets/bg.png',
              height: size.height / 3,
              width: size.height / 3,
              color: tabColor,
            ),
            SizedBox(
              height: size.height / 9,
            ),
            const Text(
              'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: greyColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width * .75,
              child: CustomButton(
                callback: () => Navigator.pushNamed(context, LoginScreen.routeName),
                text: 'AGREE AND CONTINUE',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
