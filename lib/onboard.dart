import 'package:fit_bro/screens/Auth_Screen/Login_Screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  bool _isNavigating = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  void _navigateToLogin() async {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            var fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(parent: animation, curve: curve));

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(opacity: fadeAnimation, child: child),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xCC3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 5),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xCC3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: _controller,
                        children: [
                          _buildPage(
                            imagePath: 'assets/img/3.png',
                            title: "Kickstart Your Fitness 💪",
                            subtitle: "PERSONALIZED WORKOUTS",
                            description:
                                "Get tailored workout plans designed by experts to match your fitness goals.",
                          ),
                          _buildPage(
                            imagePath: 'assets/img/3.png',
                            title: "Track Every Step 📈",
                            subtitle: "PROGRESS ANALYTICS",
                            description:
                                "Monitor your progress with detailed insights and stay motivated.",
                          ),
                          _buildPage(
                            imagePath: 'assets/img/3.png',
                            title: "Join the FitBro Tribe 🤝",
                            subtitle: "COMMUNITY SUPPORT",
                            description:
                                "Connect with fitness enthusiasts and share your journey for inspiration.",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        children: [
                          SmoothPageIndicator(
                            controller: _controller,
                            count: 3,
                            effect: ExpandingDotsEffect(
                              dotHeight: 8.h,
                              dotWidth: 8.w,
                              activeDotColor: Color(0xFFFFD60A),
                              dotColor: Colors.white.withOpacity(0.3),
                              expansionFactor: 3,
                            ),
                          ).animate().scale(
                            duration: 600.ms,
                            curve: Curves.easeInOut,
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed:
                                    _isNavigating ? null : _navigateToLogin,
                                child: Text(
                                  "Skip",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white.withOpacity(0.8),
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: Offset(1, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ).animate().fadeIn(
                                duration: 800.ms,
                                delay: 200.ms,
                              ),
                              GestureDetector(
                                onTap:
                                    _isNavigating
                                        ? null
                                        : () {
                                          if (_currentPage == 2) {
                                            _navigateToLogin();
                                          } else {
                                            _controller.nextPage(
                                              duration: const Duration(
                                                milliseconds: 500,
                                              ),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFFD60A),
                                        Color(0xCCFFD60A),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(25.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(
                                          0xFFFFD60A,
                                        ).withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30.w,
                                    vertical: 12.h,
                                  ),
                                  child:
                                      _isNavigating
                                          ? SizedBox(
                                            width: 20.w,
                                            height: 20.h,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                          : Text(
                                            _currentPage == 2
                                                ? "Get Started"
                                                : "Next",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.white,
                                              fontFamily: 'Quicksand',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                ),
                              ).animate().scale(
                                duration: 800.ms,
                                delay: 400.ms,
                                curve: Curves.easeOut,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPage({
    required String imagePath,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF22C55E).withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Image.asset(
                  imagePath,
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ).animate().slideY(
                  duration: 800.ms,
                  begin: 0.2,
                  end: 0,
                  curve: Curves.easeOut,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Quicksand',
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(1, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
              SizedBox(height: 10.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  fontFamily: 'Quicksand',
                ),
              ).animate().fadeIn(duration: 800.ms, delay: 300.ms),
              SizedBox(height: 15.h),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                  fontFamily: 'Quicksand',
                  height: 1.5,
                ),
              ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
