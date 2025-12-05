// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp()); // No SystemChrome needed
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Lakbay',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            fontFamily: 'Poppins',
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'Poppins',
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system, // Follow device setting
          home: const LoginScreen(),
        );
      },
    );
  }
}