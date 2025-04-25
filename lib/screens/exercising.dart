import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FitBro/common/color_extension.dart';
import 'package:FitBro/models/blocs/cubit/AuthCubit/auth_cubit.dart';
import 'package:FitBro/models/blocs/cubit/StoreCubit/srore_cubit.dart';
import 'package:FitBro/models/blocs/cubit/workoutcubit.dart';
import 'package:FitBro/models/data/data.dart';
import 'package:FitBro/view/menu/menu_view.dart';

class WorkoutSessionScreen extends StatefulWidget {
  const WorkoutSessionScreen({super.key});

  @override
  _WorkoutSessionScreenState createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  int currentExerciseIndex = 0;
  late List<WorkoutData> workoutDataList;
  late DateTime startTime;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    workoutDataList = context.read<ExerciseCubit>().workout;
  }

  void _nextExercise() {
    if (currentExerciseIndex < workoutDataList.length - 1) {
      setState(() {
        currentExerciseIndex++;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No more exercises!')));
    }
  }

  void _done() async {
    final finishTime = DateTime.now();

    final workoutSession = WorkoutSession(
      startTime: startTime,
      finishTime: finishTime,
      workoutData: workoutDataList,
    );

    SaveCubit().setUserExcersiceInfo(
      endDate: workoutSession.finishTime.toString(),
      startDate: workoutSession.startTime.toString(),
      listWorkOuts: workoutSession.workoutData,
    );

    context.read<ExerciseCubit>().workout.clear();

    // Show congratulatory dialog
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Congratulations!"),
            content: const Text(
              "You finished your workout.\n Keep going strong! ",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Continue"),
              ),
            ],
          ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create: (context) => AuthCubit()..getUserInfoFire(),
              child: const MenuView(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (workoutDataList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Workout Session',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        body: const Center(
          child: Text('No exercises added.', style: TextStyle(fontSize: 18)),
        ),
      );
    }

    final currentExercise = workoutDataList[currentExerciseIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // light gray background
      appBar: AppBar(
        backgroundColor: TColor.primary,
        elevation: 0,
        title: Text(
          'Workout Session',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          if (currentExerciseIndex < workoutDataList.length - 1)
            IconButton(
              icon: const Icon(Icons.skip_next_rounded),
              onPressed: _nextExercise,
            ),
          if (currentExerciseIndex == workoutDataList.length - 1)
            IconButton(
              icon: const Icon(Icons.check_circle_outline),
              onPressed: _done,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      currentExercise.exercise.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentExercise.exercise.name,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: TColor.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentExercise.exercise.instruction,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Weights:',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...currentExercise.weights.map(
                    (w) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        w,
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (currentExerciseIndex < workoutDataList.length - 1)
              ElevatedButton(
                onPressed: _nextExercise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColor.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Next Exercise',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
              ),
            if (currentExerciseIndex == workoutDataList.length - 1)
              ElevatedButton.icon(
                onPressed: _done,
                icon: const Icon(Icons.check_circle_outline),
                label: Text(
                  'Finish Workout',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
