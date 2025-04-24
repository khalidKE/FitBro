import 'package:fit_bro/screens/Auth_Screen/SignUpFrom/SignUp_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/blocs/cubit/AuthCubit/auth_cubit.dart';
import '../../view/menu/menu_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil here
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => AuthCubit(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              var authCubit = AuthCubit.get(context);
              return Stack(
                fit: StackFit.expand,
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.1),
                        Text(
                          'Start Your Fitness Journey',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quicksand',
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ).animate().fadeIn(duration: 800.ms),
                        SizedBox(height: constraints.maxHeight * 0.05),
                        Form(
                          key: authCubit.signInFormKey,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: authCubit.signInEmailController,
                                hintText: 'Email',
                                labelText: 'Email',
                                colorBorder: const Color(0xFF22C55E),
                                suffix: SvgPicture.string(
                                  '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#22C55E" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  authCubit.signInEmailController.text = value;
                                },
                                obscureText: false,
                                readOnly: false,
                                autocorrect: true,
                              ).animate().slideX(
                                duration: 800.ms,
                                begin: -0.2,
                                end: 0,
                              ),
                              SizedBox(height: 16.h),
                              CustomTextFormField(
                                controller: authCubit.signInPasswordController,
                                hintText: 'Password',
                                labelText: 'Password',
                                colorBorder: const Color(0xFF22C55E),
                                suffix: SvgPicture.string(
                                  '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#22C55E" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 11V9a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-2"/><path d="M12 17v-6"/><circle cx="12" cy="7" r="1"/></svg>',
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  authCubit.signInPasswordController.text =
                                      value;
                                },
                                obscureText: true,
                                readOnly: false,
                                autocorrect: false,
                              ).animate().slideX(
                                duration: 800.ms,
                                begin: -0.2,
                                end: 0,
                                delay: 200.ms,
                              ),
                              SizedBox(height: 24.h),
                              BlocBuilder<AuthCubit, AuthState>(
                                builder: (context, state) {
                                  return ElevatedButton(
                                    onPressed:
                                        state is AuthLoading
                                            ? null
                                            : () {
                                              if (authCubit
                                                  .signInFormKey
                                                  .currentState!
                                                  .validate()) {
                                                authCubit
                                                    .signInWithFire()
                                                    .then((value) {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        PageRouteBuilder(
                                                          pageBuilder:
                                                              (
                                                                context,
                                                                animation,
                                                                secondaryAnimation,
                                                              ) => BlocProvider(
                                                                create:
                                                                    (context) =>
                                                                        AuthCubit()
                                                                          ..getUserInfoFire(),
                                                                child:
                                                                    const MenuView(),
                                                              ),
                                                          transitionsBuilder: (
                                                            context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child,
                                                          ) {
                                                            return FadeTransition(
                                                              opacity:
                                                                  animation,
                                                              child: child,
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    })
                                                    .catchError((error) {
                                                      showDialog(
                                                        context: context,
                                                        builder:
                                                            (
                                                              context,
                                                            ) => AlertDialog(
                                                              title: const Text(
                                                                'Sign In Failed',
                                                              ),
                                                              content: Text(
                                                                error
                                                                        .toString()
                                                                        .contains(
                                                                          'invalid',
                                                                        )
                                                                    ? 'Invalid email or password'
                                                                    : 'An error occurred. Please try again.',
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () => Navigator.pop(
                                                                        context,
                                                                      ),
                                                                  child:
                                                                      const Text(
                                                                        'OK',
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                      );
                                                    });
                                              }
                                            },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 2,
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      minimumSize: Size(double.infinity, 50.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          25.r,
                                        ),
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF22C55E),
                                            Color(0xCC22C55E),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          25.r,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      height: 50.h,
                                      child:
                                          state is AuthLoading
                                              ? SizedBox(
                                                width: 24.w,
                                                height: 24.h,
                                                child:
                                                    const CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(Colors.white),
                                                    ),
                                              )
                                              : Text(
                                                'Sign In',
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Quicksand',
                                                ),
                                              ),
                                    ),
                                  );
                                },
                              ).animate().scale(
                                duration: 800.ms,
                                delay: 400.ms,
                              ),
                              SizedBox(height: 16.h),
                              TextButton(
                                onPressed: () async {
                                  final email =
                                      authCubit.signInEmailController.text
                                          .trim();
                                  if (email.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please enter your email',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  try {
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(email: email);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Password reset email sent',
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text('Error'),
                                            content: const Text(
                                              'Failed to send reset email. Please check your email and try again.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: const Color(0xFF22C55E),
                                    fontFamily: 'Quicksand',
                                  ),
                                ),
                              ).animate().fadeIn(
                                duration: 800.ms,
                                delay: 600.ms,
                              ),
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
                                          ) => const SignUpScreen(),
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
                                    text: "Don't have an account? ",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: const Color(0xFF1E293B),
                                      fontFamily: 'Quicksand',
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Sign Up",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: const Color(0xFF22C55E),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).animate().fadeIn(
                                duration: 800.ms,
                                delay: 800.ms,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 150.h,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF3B82F6), Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final Color colorBorder;
  final Widget suffix;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?) validator;
  final void Function(String) onChanged;
  final bool obscureText;
  final bool readOnly;
  final bool autocorrect;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.colorBorder,
    required this.suffix,
    required this.keyboardType,
    required this.textInputAction,
    required this.validator,
    required this.onChanged,
    required this.obscureText,
    required this.readOnly,
    required this.autocorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          labelStyle: TextStyle(
            color: const Color(0xFF1E293B),
            fontSize: 16.sp,
            fontFamily: 'Quicksand',
          ),
          hintStyle: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: 16.sp,
            fontFamily: 'Quicksand',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: colorBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: colorBorder.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: colorBorder, width: 2),
          ),
          suffixIcon: suffix,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscureText,
        readOnly: readOnly,
        autocorrect: autocorrect,
      ),
    );
  }
}
