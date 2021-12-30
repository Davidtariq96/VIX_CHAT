import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vix_chat/screens/registration.dart';
import 'package:vix_chat/screens/login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:vix_chat/helper_class.dart';

class WelcomeScreen extends StatefulWidget {
  static String home = "welcome_screen";
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    child: Image.asset('images/logo.png'),
                    height: animation.value * 100,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: 250.0,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "Vix Chat",
                            speed: const Duration(milliseconds: 90),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            MultiPurposeButton(
              inputText: "Log In",
              buttonColor: Colors.teal.shade600,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            MultiPurposeButton(
                inputText: "Register",
                buttonColor: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                })
          ],
        ),
      ),
    );
  }
}
