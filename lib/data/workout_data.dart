import 'package:exercise/data/hive_database.dart';
import 'package:exercise/models/exercise.dart';
import 'package:exercise/models/workout.dart';
import 'package:flutter/cupertino.dart';

class WorkoutData extends ChangeNotifier{

  final db = HiveDataBase();

  // List to store workout objects
  List<Workout> workoutList = [
    Workout(
      name: "Upper Body",
      exercises: [
        Exercise(
            name: "Bicep Curls",
            weight: "10",
            reps: "10",
            sets: "3"
        )],
    ),
  ];

  // if there are workouts already in database
  void initilizationworkoutlist(){
    if(db.previousDataExists()){
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }
  }
  //get workout list
  List<Workout> getWorkoutList(){
    return workoutList;
  }
   int numberofexrciseInworkout(String workoutName){
    Workout releventworkout = getReleventWorkout(workoutName);

    return releventworkout.exercises.length;
   }


  //Add a workout
  void addworkout (String name){
    //ADD a new workout with a blank list of exercise
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();
  }
  // Add an exercise to a workout
  void addExercise(String workoutname, String exerciseName, String weight,
      String reps, String sets){

    Workout relevantWorkout = getReleventWorkout(workoutname);

    relevantWorkout.exercises.add(
      Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets)
    );
    notifyListeners();
  }
  //check of exercise
void checkoffExercise(String workoutName, String exerciseName){
    Exercise relevantExercise = getReleventExercise(workoutName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
}

  // return relevent workobject, given a workout name
  Workout getReleventWorkout(String workoutName){
    Workout relevantWorkout = workoutList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  Exercise getReleventExercise(String workoutname, String ExerciseName) {
    Workout releventWorkout = getReleventWorkout(workoutname);

    Exercise relventExercise =
    releventWorkout.exercises.firstWhere((exercise) => exercise.name == ExerciseName);
  return relventExercise;
  }
}