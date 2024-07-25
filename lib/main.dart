import 'package:aplicacion_finanzas/firebase_options.dart';
import 'package:aplicacion_finanzas/screen/login_screen.dart';
import 'package:aplicacion_finanzas/screen/menu.dart';
import 'package:aplicacion_finanzas/screen/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aplicacion_finanzas/screen/splash_screen.dart';





Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => Menu(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}


