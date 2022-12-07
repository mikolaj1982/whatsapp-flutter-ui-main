import 'package:flutter/material.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_information.dart';
import 'package:whatsapp_ui/features/chat/screens/mobile_chat_screen.dart';

import 'common/widgets/error.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/landing/screens/landing_screen.dart';
import 'features/select_contacts/screens/select_contacts_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case LandingScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LandingScreen());
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                verificationId: verificationId,
              ));
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SelectContactsScreen());
    case UserInformation.routeName:
      return MaterialPageRoute(builder: (context) => const UserInformation());
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                name: name,
                uid: uid,
              ));
    default:
      return MaterialPageRoute(builder: (context) => const ErrorScreen(error: 'This page doesn\'t exist.'));
  }
}
