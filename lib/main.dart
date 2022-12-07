import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/widgets/error.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/auth/providers/auth_providers.dart';
import 'package:whatsapp_ui/router.dart';

import 'colors.dart';
import 'features/landing/screens/landing_screen.dart';
import 'features/status/screens/mobile_layout_screen.dart';
import 'firebase_options.dart';

void main() async {
  // HttpOverrides.global = MyProxyHttpOverride();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

// if used in build function it will be ref.watch
class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataProvider).when(
          data: (user) {
            if (user == null) {
              return const LandingScreen();
            }
            return const MobileLayoutScreen();
          },
          error: (e, trace) {
            return ErrorScreen(error: e.toString());
          },
          loading: () => const Loader()),
    );
  }
}

// class MyProxyHttpOverride extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..findProxy = (uri) {
//         return "PROXY localhost:8888;";
//       }
//       ..badCertificateCallback = null;
//   }
// }
