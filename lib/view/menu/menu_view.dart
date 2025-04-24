import 'dart:ui';
import 'package:fit_bro/models/blocs/cubit/AuthCubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_bro/models/blocs/cubit/StoreCubit/srore_cubit.dart';
import 'package:fit_bro/screens/Auth_Screen/Login_Screen.dart';
import 'package:fit_bro/screens/presets.dart';
import 'package:fit_bro/view/menu/yoga_view.dart';
import 'package:fit_bro/view/settings/setting_view.dart';
import '../../common/color_extension.dart';
import '../../common_widget/plan_row.dart';
import '../../screens/ExerciseHistoryScreen/ExerciseHistoryScreen.dart';
import '../exercise/exercise_view_2.dart';
import '../meal_plan/meal_plan_view_2.dart';
import '../tips/tips_view.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView>
    with SingleTickerProviderStateMixin {
  // Animation controller for menu items
  late AnimationController _animationController;

  // Page controller for image carousel
  late PageController _pageController;
  int _currentPage = 0;

  // Define fitness color theme - green to black gradient
  final Map<String, Color> fitColors = {
    "primary": const Color(0xFF1E5128), // Dark green
    "secondary": const Color(0xFF4E9F3D), // Medium green
    "accent": const Color(0xFF8FB339), // Light green
    "light": const Color(0xFFD8E9A8), // Very light green
    "dark": const Color(0xFF191A19), // Almost black
    "black": Colors.black, // Pure black
    "background": const Color(0xFFF5F5F5), // Light background
  };

  // Image carousel items
  final List<Map<String, dynamic>> carouselItems = [
    {"image": "assets/img/1.png", "subtitle": "Stay fit and healthy"},
    {"image": "assets/img/2.png", "subtitle": "Boost your endurance"},
    {"image": "assets/img/3.png", "subtitle": "Build muscle power"},
    {"image": "assets/img/5.png", "subtitle": "Improve your range of motion"},
  ];

  List planArr = [
    {
      "name": "My Favorites",
      "icon": "assets/img/menu_support.png",
      "right_icon": "",
      "color": 0xFF4E9F3D,
    },
    {
      "name": "Support",
      "icon": "assets/img/menu_support.png",
      "right_icon": "",
      "color": 0xFF4E9F3D,
    },
    {
      "name": "Settings",
      "icon": "assets/img/menu_settings.png",
      "right_icon": "",
      "color": 0xFF1E5128,
    },

    {
      "name": "Terms and Conditions",
      "icon": "assets/img/information.png",
      "right_icon": "",
      "color": 0xFF1E5128,
    },
  ];

  List menuArr = [
    {
      "name": "Workout",
      "image": "assets/img/menu_weight.png",
      "tag": "2",
      "color": 0xFF1E5128,
    },
    {
      "name": "Meal Plan",
      "image": "assets/img/menu_meal_plan.png",
      "tag": "5",
      "color": 0xFF1E5128,
    },
    {
      "name": "Exercises",
      "image": "assets/img/menu_exercises.png",
      "tag": "8",
      "color": 0xFF1E5128,
    },
    {
      "name": "Tips",
      "image": "assets/img/menu_tips.png",
      "tag": "9",
      "color": 0xFF1E5128,
    },

    {
      "name": "Yoga",
      "image": "assets/img/yoga.png",
      "tag": "1",
      "right_icon": "",
      "color": 0xFF1E5128,
    },
    {
      "name": "History",
      "image": "assets/img/walking.png",
      "tag": "12",
      "color": 0xFF1E5128,
    },
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();

    // Initialize page controller for image carousel
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0, // Full width for each slide
    );

    // Auto-scroll carousel
    _startCarouselTimer();

    // Fetch user info after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final authCubit = BlocProvider.of<AuthCubit>(context, listen: false);
        authCubit.getUserInfoFire();
      }
    });
  }

  // Auto-scroll carousel timer
  void _startCarouselTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        if (_currentPage < carouselItems.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );

        _startCarouselTimer();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Build a custom menu item with green-to-black color scheme
  Widget _buildMenuItem(Map mObj, int index) {
    // Calculate delay for staggered animation (safe values between 0.0 and 1.0)
    final double delay = (index / menuArr.length) * 0.5; // Max delay is 0.5

    // Create animation with delay
    final Animation<double> animation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(delay, 1.0, curve: Curves.easeOut),
    );

    // Get color from the menu object or use default
    Color itemColor = Color(mObj["color"] ?? 0xFF1E5128);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.6 + (0.4 * animation.value), // Scale from 0.6 to 1.0
          child: Opacity(
            opacity: animation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: itemColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    // Add haptic feedback
                    HapticFeedback.lightImpact();

                    switch (mObj["tag"].toString()) {
                      case "2":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkoutPicker(),
                          ),
                        );
                        break;
                      case "5":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MealPlanView2(),
                          ),
                        );
                        break;
                      case "8":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExerciseView2(),
                          ),
                        );
                        break;
                      case "9":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TipsView(),
                          ),
                        );
                        break;
                      case "1":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const YogaView(),
                          ),
                        );
                        break;

                      case "12":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BlocProvider(
                                  create:
                                      (context) =>
                                          SaveCubit()..getUserExcersiceInfo(),
                                  child: const ExerciseHistoryScreen(),
                                ),
                          ),
                        );
                        break;
                      default:
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: itemColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            mObj["image"] ?? "",
                            width: 30,
                            height: 30,
                            color: itemColor,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          mObj["name"] ?? "",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: fitColors["dark"],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Tap to view",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Build animated image carousel item
  Widget _buildCarouselItem(int index, BuildContext context) {
    final item = carouselItems[index];

    return Stack(
      children: [
        // Full-size image with no margins
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.6,
          child: Hero(
            tag: "carousel_${item["subtitle"]}", // Changed tag to use subtitle
            child: Image.asset(
              item["image"],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  fitColors["dark"]!.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),
        // Text content
        Positioned(
          bottom:
              10, // Adjusted to ensure text is visible but not overlapping with profile
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["subtitle"],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Build carousel indicator dots
  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        carouselItems.length,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _currentPage == index
                    ? fitColors["secondary"]
                    : fitColors["light"],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        width: media.width,
        backgroundColor: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5),
          child: Stack(
            children: [
              Container(
                width: media.width * 0.78,
                decoration: BoxDecoration(
                  color: TColor.white,
                  boxShadow: [
                    BoxShadow(
                      color: fitColors["dark"]!.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(5, 0),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Column(
                      children: [
                        SizedBox(
                          height: kTextTabBarHeight,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22.5),
                                  border: Border.all(
                                    color: fitColors["secondary"]!,
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(22.5),
                                  child: Image.asset(
                                    "assets/img/u1.png",
                                    width: 45,
                                    height: 45,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  "Training Plan",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: fitColors["primary"],
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Divider(color: fitColors["light"], height: 1),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            itemCount: planArr.length,
                            itemBuilder: (context, index) {
                              var itemObj = planArr[index] as Map? ?? {};
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: PlanRow(
                                  mObj: itemObj,
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    switch (itemObj["name"]) {
                                      case "Settings":
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const SettingsView(),
                                          ),
                                        );
                                        break;
                                      case "My Favorites":
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const SettingsView(),
                                          ),
                                        );
                                        break;
                                      // case "Terms and Conditions":

                                      //   break;
                                      case "Support":
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Color(0xFF1E5128),
                                            content: const Text(
                                              'Contact us at: abuelhassan179@gmail.com',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            duration: const Duration(
                                              seconds: 5,
                                            ),
                                            action: SnackBarAction(
                                              label: 'OK',
                                              textColor: Colors.white,
                                              onPressed: () {},
                                            ),
                                          ),
                                        );
                                        break;
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Divider(color: fitColors["light"], height: 1),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: kTextTabBarHeight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  HapticFeedback.mediumImpact();
                                  final authCubit = BlocProvider.of<AuthCubit>(
                                    context,
                                  );
                                  authCubit.signOut().then((value) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const LoginScreen(),
                                      ),
                                    );
                                  });
                                },
                                child: Text(
                                  "log out",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: fitColors["primary"],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Image.asset(
                                  "assets/img/next.png",
                                  width: 18,
                                  height: 18,
                                  color: fitColors["primary"],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: kToolbarHeight - 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image.asset(
                            "assets/img/meun_close.png",
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Animated Image Carousel with full-size images
          SizedBox(
            height: media.width * 0.6,
            child: Stack(
              children: [
                // PageView for swiping images
                PageView.builder(
                  controller: _pageController,
                  itemCount: carouselItems.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildCarouselItem(index, context);
                  },
                ),

                // User profile overlay (positioned higher)
                Positioned(
                  bottom:
                      30, // Increased bottom value to move the profile section higher
                  left: 0,
                  right: 0,
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      // Get the AuthCubit instance
                      final authCubit = BlocProvider.of<AuthCubit>(context);

                      // Get user email from AuthCubit or use a default
                      String userEmail = authCubit.user?.email ?? "";

                      // Extract username from email (before @) or use "User" as default
                      String displayName = "User";
                      if (userEmail.isNotEmpty && userEmail.contains('@')) {
                        displayName = userEmail.split('@').first;
                        // Capitalize first letter
                        if (displayName.isNotEmpty) {
                          displayName =
                              displayName[0].toUpperCase() +
                              displayName.substring(1);
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 10,
                        ), // Reduced vertical padding
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: 54,
                              decoration: BoxDecoration(
                                color: TColor.white,
                                borderRadius: BorderRadius.circular(27),
                                border: Border.all(
                                  color: fitColors["secondary"]!,
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.asset(
                                  "assets/img/u1.png",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    displayName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: TColor.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Profile",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: TColor.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Carousel indicators
                Positioned(
                  bottom:
                      5, // Adjusted to place indicators below the profile section
                  left: 0,
                  right: 0,
                  child: _buildIndicator(),
                ),
              ],
            ),
          ),

          // Menu Grid
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Fitness Menu",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: fitColors["dark"],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: fitColors["secondary"]!.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "View All",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: fitColors["secondary"],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 20),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.9,
                          ),
                      itemCount: menuArr.length,
                      itemBuilder: ((context, index) {
                        var mObj = menuArr[index] as Map? ?? {};
                        return _buildMenuItem(mObj, index);
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
