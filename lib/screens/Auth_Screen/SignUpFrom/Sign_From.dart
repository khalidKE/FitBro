import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:toastification/toastification.dart';
import '../../../consts/Colors.dart';
import '../../../consts/ICons.dart';
import '../../../consts/Regex.dart';
import '../../../models/blocs/cubit/AuthCubit/auth_cubit.dart';
import '../../../update/Model/widgets/CustomTextFormFeild.dart';
import '../../../view/menu/menu_view.dart';

class SignUpForm extends StatefulWidget {
  final Function(bool) onTermsChanged;
  final bool acceptTerms;

  const SignUpForm({
    super.key,
    required this.onTermsChanged,
    required this.acceptTerms,
  });

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // List of common email domains for autocomplete
  final List<String> _emailDomains = [
    '@gmail.com',
    '@yahoo.com',
    '@hotmail.com',
    '@outlook.com',
    '@aol.com',
    '@icloud.com',
  ];

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);
    return Stack(
      children: [
        Form(
          key: authCubit.signUpFormKey,
          child: Column(
            children: [
              Autocomplete<String>(
                initialValue: TextEditingValue(
                  text: authCubit.signUpEmailController.text,
                  selection: TextSelection.fromPosition(
                    TextPosition(
                      offset: authCubit.signUpEmailController.text.length,
                    ),
                  ),
                ),
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  final input = textEditingValue.text.toLowerCase();
                  if (!input.contains('@')) {
                    return _emailDomains.map((domain) => input + domain);
                  }
                  return _emailDomains
                      .where((domain) => (input + domain).contains(input))
                      .map(
                        (domain) =>
                            input.substring(0, input.indexOf('@')) + domain,
                      );
                },
                onSelected: (String selection) {
                  authCubit.signUpEmailController.text = selection;
                },
                fieldViewBuilder: (
                  context,
                  controller,
                  focusNode,
                  onFieldSubmitted,
                ) {
                  // Don't modify controller here - use initialValue instead

                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      labelText: "Email",
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.string(ICons.mailIcon),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.red),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      labelStyle: const TextStyle(fontFamily: 'Quicksand'),
                      hintStyle: const TextStyle(fontFamily: 'Quicksand'),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      authCubit.signUpEmailController.text = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else if (!RegExp(Regex.email).hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    autocorrect: true,
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        width: MediaQuery.of(context).size.width - 32,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text(option),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              CutomTextFromFeild(
                controller: authCubit.signUpPasswordController,
                hintText: "Enter your password",
                labelText: "Password",
                suffix: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  authCubit.signUpPasswordController.text = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
                colorBorder: AppColors.red,
                obscureText: !_passwordVisible,
                readOnly: false,
                autocorrect: false,
              ),
              const SizedBox(height: 16),
              CutomTextFromFeild(
                controller: authCubit.signUpConfirmPasswordController,
                hintText: "Re-enter your password",
                labelText: "Confirm Password",
                suffix: IconButton(
                  icon: Icon(
                    _confirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  authCubit.signUpConfirmPasswordController.text = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please re-enter your password";
                  } else if (value != authCubit.signUpPasswordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
                colorBorder: AppColors.red,
                obscureText: !_confirmPasswordVisible,
                readOnly: false,
                autocorrect: false,
              ),
              const SizedBox(height: 32),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    // Set loading to false immediately
                    if (mounted) {
                      setState(() {
                        isLoading = false;
                      });

                      // Show success toast
                      toastification.show(
                        context: context,
                        title: const Text("Sign Up Success"),
                        type: ToastificationType.success,
                        style: ToastificationStyle.fillColored,
                        autoCloseDuration: const Duration(seconds: 3),
                        animationDuration: const Duration(milliseconds: 300),
                        animationBuilder: (
                          context,
                          animation,
                          alignment,
                          child,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      );

                      // Clear form fields
                      authCubit.clearControllers();

                      // Create a new AuthCubit for MenuView and navigate
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider(
                                create:
                                    (context) => AuthCubit()..getUserInfoFire(),
                                child: const MenuView(),
                              ),
                        ),
                      );
                    }
                  } else if (state is AuthError) {
                    if (mounted) {
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            authCubit.mapFirebaseError(state.error),
                          ),
                        ),
                      );
                    }
                  } else if (state is AuthLoading) {
                    if (mounted) {
                      setState(() {
                        isLoading = true;
                      });

                      // Add a timeout to prevent infinite loading
                      Future.delayed(const Duration(seconds: 10), () {
                        if (mounted && isLoading) {
                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Sign up is taking too long. Please try again.",
                              ),
                            ),
                          );
                        }
                      });
                    }
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed:
                        isLoading || !widget.acceptTerms
                            ? null
                            : () async {
                              if (authCubit.signUpFormKey.currentState!
                                  .validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  await authCubit.signUpWithFire();
                                  // Don't clear controllers here, let the AuthSuccess state handle it
                                } catch (e) {
                                  debugPrint("Sign-up error: $e");
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          authCubit.mapFirebaseError(
                                            e.toString(),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFFF7643),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    child:
                        isLoading
                            ? SizedBox(
                              width: 24,
                              height: 24,
                              child: LoadingAnimationWidget.discreteCircle(
                                color: Colors.white,
                                size: 24,
                              ),
                            )
                            : const Text("Continue"),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _mapFirebaseError(String error) {
    if (error.contains('email-already-in-use')) {
      return 'This email is already registered';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email address';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak';
    } else if (error.contains('passwords do not match')) {
      return 'Passwords do not match';
    } else {
      return 'An error occurred: $error';
    }
  }
}
