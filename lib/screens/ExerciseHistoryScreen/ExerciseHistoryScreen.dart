import 'package:FitBro/models/blocs/cubit/StoreCubit/srore_cubit.dart';
import 'package:FitBro/models/blocs/cubit/StoreCubit/srore_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../common/color_extension.dart';

class ExerciseHistoryScreen extends StatefulWidget {
  const ExerciseHistoryScreen({super.key});

  @override
  _ExerciseHistoryScreenState createState() => _ExerciseHistoryScreenState();
}

class _ExerciseHistoryScreenState extends State<ExerciseHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch exercise history when the screen is initialized
    context.read<SaveCubit>().getUserExcersiceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Exercise History",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: TColor.primary,
      ),
      body: BlocBuilder<SaveCubit, StoreState>(
        builder: (context, state) {
          if (state is LoadingGetExcersiceInfo) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            );
          } else if (state is SuccessGetExcersiceInfo) {
            if (state.workoutSessions.isEmpty) {
              return const Center(
                child: Text(
                  "No exercise history available.",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.workoutSessions.length,
              itemBuilder: (context, index) {
                final workoutSession = state.workoutSessions[index];

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        "Session ${index + 1}: ${DateFormat('yMMMd').format(workoutSession.startTime)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.teal,
                        ),
                      ),
                      subtitle: Text(
                        "Start: ${DateFormat('jm').format(workoutSession.startTime)} - End: ${DateFormat('jm').format(workoutSession.finishTime)}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      children:
                          workoutSession.workoutData.map((workoutData) {
                            return ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: workoutData.exercise.image,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) =>
                                          const CircularProgressIndicator(),
                                  errorWidget:
                                      (context, url, error) =>
                                          const Icon(Icons.image_not_supported),
                                ),
                              ),
                              title: Text(
                                workoutData.exercise.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                "Muscles: ${workoutData.exercise.muscles.join(", ")}\n"
                                "Equipment: ${workoutData.exercise.equipment}\n"
                                "Weights: ${workoutData.weights.join(", ")}",
                                style: const TextStyle(color: Colors.black54),
                              ),
                              trailing: Text(
                                workoutData.exercise.difficulty,
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                );
              },
            );
          } else if (state is ErrorGetExcersiceInfo) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Error loading history: ${state.error}",
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => context.read<SaveCubit>().getUserExcersiceInfo(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text(
              "No exercise history available.",
              style: TextStyle(fontSize: 18),
            ),
          );
        },
      ),
    );
  }
}
