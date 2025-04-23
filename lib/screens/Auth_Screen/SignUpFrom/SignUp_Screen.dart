import 'package:fit_bro/models/blocs/cubit/AuthCubit/auth_cubit.dart';
import 'package:fit_bro/screens/Auth_Screen/Login_Screen.dart';
import 'package:fit_bro/screens/Auth_Screen/SignUpFrom/Sign_From.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => AuthCubit(),
          child: Builder(
            builder:
                (context) => SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            "Create Your Account",
                            style: TextStyle(
                              color: const Color(0xFF1E293B),
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Quicksand',
                            ),
                          ).animate().fadeIn(duration: 800.ms),
                          SizedBox(height: 8.h),
                          Text(
                            "Sign up with your email",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 16.sp,
                              fontFamily: 'Quicksand',
                            ),
                          ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          SignUpForm(
                            onTermsChanged: (value) {
                              setState(() {
                                _acceptTerms = value;
                              });
                            },
                            acceptTerms: _acceptTerms,
                          ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _acceptTerms = value ?? false;
                                  });
                                },
                                activeColor: const Color(0xFFFF7643),
                              ),
                              Expanded(
                                child: Text(
                                  'I agree to the Terms and Conditions',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color(0xFF1E293B),
                                    fontFamily: 'Quicksand',
                                  ),
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 800.ms, delay: 1000.ms),
                          SizedBox(height: 16.h),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text:
                                  "By continuing, you confirm that you agree\nwith our ",
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: 14.sp,
                                fontFamily: 'Quicksand',
                              ),
                              children: [
                                TextSpan(
                                  text: "Terms and Conditions",
                                  style: TextStyle(
                                    color: const Color(0xFFFF7643),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 800.ms, delay: 1200.ms),
                          SizedBox(height: 16.h),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => const LoginScreen(),
                                  transitionsBuilder: (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text.rich(
                              TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: const Color(0xFF1E293B),
                                  fontFamily: 'Quicksand',
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign In",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: const Color(0xFFFF7643),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(duration: 800.ms, delay: 1400.ms),
                        ],
                      ),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
