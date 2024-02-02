import 'package:exercise/dataetime/Date_Time.dart';
import 'package:exercise/models/exercise.dart';
import 'package:exercise/models/workout.dart';
import 'package:hive/hive.dart';

class HiveDataBase {
  final _myBox = Hive.box("workout_database1");

  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("Previous data does NOT exist");
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("Previous data does exist");
      return true;
    }
  }

  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  void saveToDatabase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if (exerciseComplete(workouts)) {
      _myBox.put("COMPLETION_STATUS_" + todaysDateYYYYMMDD(), 1);
    } else {
      _myBox.put("COMPLETE_STATUS" + todaysDateYYYYMMDD(), 0);
    }

    // Save into Hive
    _myBox.put("Workouts", workoutList);
    _myBox.put("Exercise", exerciseList);
  }

  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];
    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISE");

    // Create workouts objects
    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exercisesInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        exercisesInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true",
          ),
        );
      }

      // Create individual workout
      Workout workout = Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);

      // Add individual workout to overall list
      mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

  bool exerciseComplete(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (!exercise.isCompleted) {
          return false;
        }
      }
    }
    return true;

  }

  int getCompletionStates(String yyyymmdd){
    int completestatus = _myBox.get("COMPLETE_STATES_$yyyymmdd") ?? 0;
    return completestatus;
  }

}

List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  return workouts.map((workout) => workout.name).toList();
}

List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  return workouts.map((workout) {
    return workout.exercises.map((exercise) {
      return [
        exercise.name,
        exercise.weight.toString(),
        exercise.reps.toString(),
        exercise.sets.toString(),
        exercise.isCompleted.toString(),
      ];
    }).toList();
  }).toList();
}