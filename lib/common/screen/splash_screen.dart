import 'package:flutter/material.dart';

import '../layout/default_layout.dart';

class SplashScreen extends StatelessWidget {
  static String get routeName => 'splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      body: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}
