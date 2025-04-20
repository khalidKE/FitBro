import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fit_bro/models/data/data.dart';
import 'package:fit_bro/models/repos/data_repo.dart';
part 'workoutcubit.freezed.dart';

@freezed
class ExerciseState with _$ExerciseState {
  const factory ExerciseState.loading() = _Loading;
  const factory ExerciseState.loaded(List<Exercise> data) = _Loaded;
  const factory ExerciseState.error(String message) = _Error;
}

class ExerciseCubit extends Cubit<ExerciseState> {
  final DataRepo _dataRepo;
  ExerciseCubit(this._dataRepo) : super(const ExerciseState.loading());
  int _selected_index = 0;
  int get selectedIndex => _selected_index;
  final List<WorkoutData> workout = [];

  void fetchdata() async {
    try {
      emit(const ExerciseState.loading());
      List<Exercise> exercises = await _dataRepo.getExercises();
      emit(ExerciseState.loaded(exercises));
    } catch (e) {
      emit(const ExerciseState.error("error"));
    }
  }

  void addWorkoutData(WorkoutData workoutdata) {
    workout.add(workoutdata);
    print(workout[0].weights.toList().toString());
  }

  void setSelectedIndex(int index) {
    _selected_index = index;
    categoriesFilter();
  }

  void categoriesFilter() async {
    List<Exercise> exercises = await _dataRepo.getExercises();
    switch (_selected_index) {
      case 0:
        emit(ExerciseState.loaded(exercises));
        break;
      case 1:
        emit(
          ExerciseState.loaded(
            exercises.where((e) => e.muscles.contains('Chest')).toList(),
          ),
        );
        break;
      case 2:
        emit(
          ExerciseState.loaded(
            exercises.where((e) => e.muscles.contains('Triceps')).toList(),
          ),
        );
        break;
      case 3:
        emit(
          ExerciseState.loaded(
            exercises.where((e) => e.muscles.contains('Shoulders')).toList(),
          ),
        );
        break;
      case 4:
        emit(
          ExerciseState.loaded(
            exercises.where((e) => e.muscles.contains('Lats')).toList(),
          ),
        );
        break;
      case 5:
        emit(
          ExerciseState.loaded(
            exercises.where((e) => e.muscles.contains('Upper Chest')).toList(),
          ),
        );
        break;
      case 6:
        emit(
          ExerciseState.loaded(
            exercises.where((e) => e.muscles.contains('Back')).toList(),
          ),
        );
        break;
      case 7:
        emit(
          ExerciseState.loaded(
            exercises.where((e) => e.muscles.contains('Biceps')).toList(),
          ),
        );
        break;
      case 8:
        emit(
          ExerciseState.loaded(
            exercises.where((e) => e.muscles.contains('Traps')).toList(),
          ),
        );
        break;
      case 9:
        emit(
          ExerciseState.loaded(
            exercises.where((e) => e.muscles.contains('Legs')).toList(),
          ),
        );
        break;
      case 10:
        emit(
          ExerciseState.loaded(
            exercises.where((e) => e.muscles.contains('Gluteus')).toList(),
          ),
        );
        break;
      case 11:
        emit(
          ExerciseState.loaded(
            exercises.where((e) => e.muscles.contains('Lower Back')).toList(),
          ),
        );
        break;
      case 12:
        emit(
          ExerciseState.loaded(
            exercises.where((e) => e.muscles.contains('Core')).toList(),
          ),
        );
        break;
      case 13:
        emit(
          ExerciseState.loaded(
            exercises.where((e) => e.muscles.contains('Full Body')).toList(),
          ),
        );
        break;
      case 14:
        emit(
          ExerciseState.loaded(
            exercises.where((e) => e.muscles.contains('Cardio')).toList(),
          ),
        );
        break;
    }
  }
}
