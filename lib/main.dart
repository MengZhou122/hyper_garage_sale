import 'package:flutter/material.dart';
import 'package:hypergaragesale/screens/category_screen.dart';
import 'package:hypergaragesale/screens/login_screen.dart';
import 'package:hypergaragesale/screens/registration_screen.dart';
import 'package:hypergaragesale/screens/welcome_screen.dart';

void main() => runApp(HyperGS());

class HyperGS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id, //CategoryScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        CategoryScreen.id: (context) => CategoryScreen(),
        //delete after complete
      },
    );
  }
}
