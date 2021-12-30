import 'package:flutter/material.dart';
import 'screens/welcome.dart';
import 'screens/registration.dart';
import 'package:vix_chat/screens/login.dart';
import 'package:vix_chat/screens/chat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.home,
      routes: {
        WelcomeScreen.home: (context) => const WelcomeScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        '/chat': (context) => const ChatScreen()
      },
    );
  }
}
//import 'package:firebase_core/firebase_core.dart';
