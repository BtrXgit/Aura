// OM Namah Shivay
//          /----
//==========-------
//          \----

import 'package:aura/authentication/auth%20pages/auth_page.dart';
import 'package:aura/firebase_options.dart';
import 'package:aura/home.dart';
import 'package:aura/util/provider/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Future.wait([
    _initSharedPreferences(),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: GetMaterialApp(
        home: AuthPage(
            // title: 'Aura',
            ),
      ),
    );
  }
}

Future<void> _initSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
}
