import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fit_bro/common/color_extension.dart';
import 'package:fit_bro/models/blocs/cubit/workoutcubit.dart';
import 'package:fit_bro/models/data/data.dart';
import 'package:fit_bro/screens/exercising.dart';
import 'package:fit_bro/view/exercise/exercise_view_2.dart';

class WorkoutPicker extends StatelessWidget {
  const WorkoutPicker({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> muscles = [
      'All',
      'Chest',
      'Triceps',
      'Shoulders',
      'Lats',
      'Upper Chest',
      'Back',
      'Biceps',
      'Traps',
      'Legs',
      'Gluteus',
      'Lower Back',
      'Core',
      'Full Body',
      'Cardio',
    ];

    return BlocBuilder<ExerciseCubit, ExerciseState>(
      builder: (context, state) {
        return state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded:
              (data) => Scaffold(
                backgroundColor: Colors.grey[50],
                appBar: AppBar(
                  elevation: 0,
                  title: Text(
                    "Pick Your Workout",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: TColor.primary,
                ),
                body: Column(
                  children: [
                    MuscleTabs(muscles: muscles),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return ExerciseTile(exercise: data[index]);
                        },
                      ),
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const WorkoutSessionScreen(),
                      ),
                    );
                  },
                  backgroundColor: TColor.primary,
                  icon: const Icon(FontAwesomeIcons.play),
                  label: const Text("Start Workout"),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              ),
          error: (message) => Center(child: Text("Error: $message")),
        );
      },
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  const ExerciseTile({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(exercise.image),
          radius: 28,
        ),
        title: Text(
          exercise.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        trailing: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder:
                    (context) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: SingleChildScrollView(
                        child: ModelSheet(exercise: exercise),
                      ),
                    ),
              );
            },
            icon: const Icon(FontAwesomeIcons.plus, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ModelSheet extends StatefulWidget {
  final Exercise exercise;
  const ModelSheet({super.key, required this.exercise});

  @override
  _ModelSheetState createState() => _ModelSheetState();
}

class _ModelSheetState extends State<ModelSheet> {
  final List<TextEditingController> weightControllers = [];

  @override
  void initState() {
    super.initState();
    _addNewRow();
  }

  @override
  void dispose() {
    for (var controller in weightControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addNewRow() {
    final controller = TextEditingController();
    controller.addListener(() => setState(() {}));
    setState(() => weightControllers.add(controller));
  }

  void _removeRow(int index) {
    if (weightControllers.length > 1) {
      setState(() {
        weightControllers[index].dispose();
        weightControllers.removeAt(index);
      });
    }
  }

  bool get _hasEmptyFields =>
      weightControllers.any((controller) => controller.text.isEmpty);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Add sets for ${widget.exercise.name}",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(weightControllers.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: weightControllers[index],
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Weight ${index + 1}',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.red),
                    onPressed: () => _removeRow(index),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed:
                    _hasEmptyFields
                        ? null
                        : () {
                          final weights =
                              weightControllers
                                  .map((controller) => controller.text)
                                  .toList();
                          context.read<ExerciseCubit>().addWorkoutData(
                            WorkoutData(
                              exercise: widget.exercise,
                              weights: weights,
                            ),
                          );
                          Navigator.pop(context);
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _hasEmptyFields ? Colors.grey : TColor.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Add Exercise'),
              ),
              ElevatedButton(
                onPressed: _addNewRow,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: const Text('Add Row'),
              ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
