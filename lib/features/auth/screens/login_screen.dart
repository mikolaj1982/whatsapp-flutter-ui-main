import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/custom_button.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  void pickCountry() {
    showCountryPicker(
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
      context: context,
      favorite: <String>['SE', 'PL', 'NZ'],
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      String fullPhoneNumber = '+${country!.phoneCode}$phoneNumber';
      debugPrint('fullPhoneNumber: $fullPhoneNumber');
      ref.read(authControllerProvider).signInWithPhone(context, fullPhoneNumber);
    } else {
      showSnackBar(context: context, content: 'Fill out all the fields.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number.'),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('WhatsApp will need to verify your phone number.'),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                // we do not need to pass any arguments so pickCountry is enough
                onPressed: pickCountry,
                child: const Text('Pick Country'),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  if (country != null) Text('+${country!.phoneCode}'),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: size.width * .7,
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(hintText: 'phone number'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .5,
              ),
              SizedBox(
                width: 90,
                child: CustomButton(
                  callback: sendPhoneNumber,
                  text: 'NEXT',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }
}
