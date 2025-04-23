import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_bro/models/blocs/cubit/AuthCubit/auth_cubit.dart';
import 'package:fit_bro/models/blocs/cubit/StoreCubit/srore_cubit.dart';
import 'package:fit_bro/screens/Auth_Screen/Login_Screen.dart';
import 'package:fit_bro/screens/presets.dart';
import 'package:fit_bro/view/menu/yoga_view.dart';
import 'package:fit_bro/view/settings/setting_view.dart';
import '../../common/color_extension.dart';
import '../../common_widget/menu_cell.dart';
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

class _MenuViewState extends State<MenuView> {
  List planArr = [
    {
      "name": "Running",
      "icon": "assets/img/menu_running.png",
      "right_icon": "",
    },
    {
      "name": "Yoga",
      "icon": "assets/img/yoga.png",
      "right_icon": "assets/img/information.png",
    },
    {"name": "Workout", "icon": "assets/img/workout.png", "right_icon": ""},
    {"name": "Walking", "icon": "assets/img/walking.png", "right_icon": ""},
    {
      "name": "Fitness",
      "icon": "assets/img/fitness.png",
      "right_icon": "assets/img/information.png",
    },
    {"name": "Strength", "icon": "assets/img/strength.png", "right_icon": ""},
  ];

  List menuArr = [
    {"name": "Workout", "image": "assets/img/menu_weight.png", "tag": "2"},
    {"name": "Meal Plan", "image": "assets/img/menu_meal_plan.png", "tag": "5"},
    {"name": "Exercises", "image": "assets/img/menu_exercises.png", "tag": "8"},
    {"name": "Tips", "image": "assets/img/menu_tips.png", "tag": "9"},
    {"name": "Settings", "image": "assets/img/menu_settings.png", "tag": "10"},
    {"name": "Support", "image": "assets/img/menu_support.png", "tag": "11"},
    {"name": "History", "image": "assets/img/menu_running.png", "tag": "12"},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    // Fetch user info on initialization
    final authCubit = context.read<AuthCubit>();
    authCubit.getUserInfoFire();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    var authCubit = AuthCubit.get(context);
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
                decoration: BoxDecoration(color: TColor.white),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Column(
                      children: [
                        SizedBox(
                          height: kTextTabBarHeight,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(22.5),
                                child: Image.asset(
                                  "assets/img/u1.png",
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  "Training Plan",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: TColor.secondaryText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Divider(color: Colors.black26, height: 1),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            itemCount: planArr.length,
                            itemBuilder: (context, index) {
                              var itemObj = planArr[index] as Map? ?? {};
                              return PlanRow(
                                mObj: itemObj,
                                onPressed: () {
                                  if (index == 1) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const YogaView(),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        const Divider(color: Colors.black26, height: 1),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: kTextTabBarHeight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
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
                                    fontSize: 20,
                                    color: TColor.secondaryText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Image.asset(
                                  "assets/img/next.png",
                                  width: 18,
                                  height: 18,
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.black,
              expandedHeight: media.width * 0.6,
              collapsedHeight: kToolbarHeight + 20,
              flexibleSpace: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Image.asset(
                    "assets/img/1.png",
                    width: media.width,
                    height: media.width * 0.8,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: media.width,
                    height: media.width * 0.8,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 30,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: 54,
                              decoration: BoxDecoration(
                                color: TColor.white,
                                borderRadius: BorderRadius.circular(27),
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
                                    authCubit.user?.userName ?? "User",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: TColor.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Profile",
                                    style: TextStyle(
                                      fontSize: 15,
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
                ],
              ),
            ),
          ];
        },
        body: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1,
          ),
          itemCount: menuArr.length,
          itemBuilder: ((context, index) {
            var mObj = menuArr[index] as Map? ?? {};
            return MenuCell(
              mObj: mObj,
              onPressed: () {
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
                      MaterialPageRoute(builder: (context) => const TipsView()),
                    );
                    break;
                  case "10":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsView(),
                      ),
                    );
                    break;
                  case "11":
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Contact us at: fit@workouttracking.com',
                        ),
                        duration: const Duration(seconds: 5),
                        action: SnackBarAction(label: 'OK', onPressed: () {}),
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
            );
          }),
        ),
      ),
    );
  }
}
