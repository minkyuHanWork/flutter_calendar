import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static String get routeName => 'splash';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F5F4),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/image/splash.jpeg',
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ));
  }
}
