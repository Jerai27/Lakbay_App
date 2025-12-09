// lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // ← ADD THIS
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    // Set status bar to light background with dark icons
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF5F5F5),  // Light gray background
        statusBarIconBrightness: Brightness.dark,  // Dark icons
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brownPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40.h, bottom: 20.h),
              child: SvgPicture.asset('assets/images/Lakbay_Logo.svg',
                  height: 90.h, color: Colors.white.withOpacity(0.9)),
            ),
            Text('Create Account',
                style: GoogleFonts.poppins(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text('Start your travel adventure today',
                style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.white70)),

            SizedBox(height: 30.h),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
                  ),
                ),
                padding: EdgeInsets.all(30.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextField(
                          hintText: 'Your Full Name',
                          icon: Icons.person_outline),
                      CustomTextField(
                          hintText: 'Your@email.com',
                          icon: Icons.email_outlined),
                      CustomTextField(
                          hintText: 'Create a strong password',
                          icon: Icons.lock_outline,
                          isPassword: true),
                      CustomTextField(
                          hintText: 'Re-enter your password',
                          icon: Icons.lock_outline,
                          isPassword: true),

                      SizedBox(height: 30.h),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brownPrimary,
                          minimumSize: Size(double.infinity, 60.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r)),
                        ),
                        child: Text('Create Account',
                            style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),

                      SizedBox(height: 30.h),
                      Text('Or sign up with',
                          style: GoogleFonts.poppins(color: AppColors.textGray)),

                      SizedBox(height: 20.h),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: SvgPicture.asset('assets/icons/google.svg',
                            height: 24.h),
                        label: Text('Continue with Google',
                            style: GoogleFonts.poppins(
                                fontSize: 16.sp, color: Colors.black87)),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60.h),
                          side: BorderSide(color: Colors.brown.shade200),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r)),
                        ),
                      ),

                      SizedBox(height: 30.h),
                      Text(
                        'By signing up, you agree to our Terms of Service and Privacy Policy',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 12.sp, color: AppColors.textGray),
                      ),

                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account? ',
                              style: GoogleFonts.poppins(color: Colors.black87)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text('Sign In',
                                style: GoogleFonts.poppins(
                                    color: AppColors.brownPrimary,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
