import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  
   Widget build(BuildContext context) {
    return MaterialApp(
      
      home: Scaffold(
         backgroundColor: Color.fromARGB(255, 0, 168, 190), 
        appBar: AppBar(
          title: Text('Bienvenidos Finanzas App'),
          backgroundColor:  Colors.cyan,
        ),
        body: Center(
          child: Container(
            width: 150.0,
            height: 150.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            padding: EdgeInsets.all(10.0),
            child: ClipOval(
              child: Image.network(
                "https://picsum.photos/id/870/200/300?grayscale&blur=2",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
