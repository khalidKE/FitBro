import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FitBro/common/color_extension.dart';
import 'package:FitBro/models/blocs/cubit/mealcubit.dart';
import 'package:FitBro/models/data/data.dart';
import 'package:FitBro/models/repos/data_repo.dart';
import 'package:FitBro/screens/mealdetalis.dart';

class MealPlanView2 extends StatelessWidget {
  const MealPlanView2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MealCubit(DataRepo())..fetchMeals(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Recommended Meals",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: TColor.primary,
          elevation: 0,
          centerTitle: true,
        ),
        body: BlocBuilder<MealCubit, MealState>(
          builder: (context, state) {
            return state.when(
              loading:
                  () => Center(
                    child: CircularProgressIndicator(color: TColor.primary),
                  ),
              loaded: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => MealCard(meal: data[index]),
                );
              },
              error: (message) => Center(child: Text("Error: $message")),
            );
          },
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final Meal meal;
  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MealDetailView(meal: meal)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.network(
                      meal.image_url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          height: 220,
                          width: double.infinity,
                          child: const Icon(
                            Icons.error,
                            color: Colors.white,
                            size: 50,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                            color: TColor.primary,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calories',
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          meal.calories.toString(),
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              meal.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "A delicious and nutritious meal to keep you energized.",
              style: TextStyle(
                color: TColor.secondaryText.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: TColor.primary.withOpacity(0.2), thickness: 1),
          ],
        ),
      ),
    );
  }
}
