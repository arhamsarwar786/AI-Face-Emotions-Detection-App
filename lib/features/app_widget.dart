import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_example/features/home/view/splash_screen.dart';
import 'home/view/home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
