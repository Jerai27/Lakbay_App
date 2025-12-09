import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/forgot_password_modal.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFF5F5F5),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await AuthService().login(email: email, password: password);

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
      } else {
        // SUCCESS → Go to home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(userName: email)),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brownPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // TOP LOGO
            Container(
              padding: EdgeInsets.only(top: 60.h, bottom: 40.h),
              child: Column(
                children: [
                  SvgPicture.asset('assets/images/Lakbay_Logo.svg', height: 80.h),
                  SizedBox(height: 20.h),
                  Text('Lakbay',
                      style: GoogleFonts.poppins(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  Text('Plan your journey together',
                      style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.white70)),
                ],
              ),
            ),

            // WHITE CARD
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r)),
                ),
                padding: EdgeInsets.all(30.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Welcome Back!',
                          style: GoogleFonts.poppins(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          )),
                      Text('Sign in to continue your travel planning',
                          style: GoogleFonts.poppins(fontSize: 14.sp, color: AppColors.textGray)),

                      SizedBox(height: 30.h),

                      CustomTextField(
                        controller: emailController,
                        hintText: 'Your@email.com',
                        icon: Icons.email_outlined,
                      ),
                      CustomTextField(
                        controller: passwordController,
                        hintText: 'Enter your password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const ForgotPasswordModal(),
                            );
                          },
                          child: Text('Forgot Password?',
                              style: GoogleFonts.poppins(color: AppColors.brownPrimary)),
                        ),
                      ),

                      // SIGN IN BUTTON
                      ElevatedButton(
                        onPressed: isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brownPrimary,
                          minimumSize: Size(double.infinity, 60.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text('Sign In',
                                style: GoogleFonts.poppins(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                )),
                      ),

                      SizedBox(height: 30.h),
                      Text('Or continue with',
                          style: GoogleFonts.poppins(color: AppColors.textGray)),
                      SizedBox(height: 20.h),

                      // GOOGLE LOGIN
                      OutlinedButton.icon(
                        onPressed: () async {
                          final res = await AuthService().signInWithGoogle();
                          if (res == null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => HomeScreen(userName: "Google User")),
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(res)));
                          }
                        },
                        icon: SvgPicture.asset('assets/icons/google.svg', height: 24),
                        label: Text('Continue with Google',
                            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87)),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 60),
                          side: BorderSide(color: Colors.brown.shade200),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",
                              style: GoogleFonts.poppins(color: Colors.black87)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
                            },
                            child: Text('Sign Up',
                                style: GoogleFonts.poppins(
                                  color: AppColors.brownPrimary,
                                  fontWeight: FontWeight.w600,
                                )),
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
