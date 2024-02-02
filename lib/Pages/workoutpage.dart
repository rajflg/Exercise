import 'package:exercise/components/exercise_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exercise/data/workout_data.dart';

class WorkoutPage extends StatelessWidget {
  final String workoutName;

  WorkoutPage({Key? key, required this.workoutName}) : super(key: key);

  // Handle checkbox state change
  void onCheckBoxChanged(BuildContext context, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkoffExercise(workoutName, exerciseName);
  }

  final TextEditingController exercisenameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController setsController = TextEditingController();

  void createNewExercise(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add a new exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Exercise Name
            TextField(
              controller: exercisenameController,
              decoration: InputDecoration(labelText: 'Exercise Name'),
            ),
            // Weight
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight'),
            ),
            // Reps
            TextField(
              controller: repsController,
              decoration: InputDecoration(labelText: 'Reps'),
            ),
            // Sets
            TextField(
              controller: setsController,
              decoration: InputDecoration(labelText: 'Sets'),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: () => save(context),
            child: Text("Save"),
          ),
          MaterialButton(
            onPressed: () => back(context),
            child: Text("Back"),
          ),
        ],
      ),
    );
  }

  void save(BuildContext context) {
    String newExerciseName = exercisenameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    Provider.of<WorkoutData>(context, listen: false).addExercise(
      workoutName,
      newExerciseName,
      weight,
      reps,
      sets,
    );

    Navigator.pop(context);
    clear();
  }

  void back(BuildContext context) {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exercisenameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, workoutData, child) => Scaffold(
        appBar: AppBar(
          title: Text(workoutName),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => createNewExercise(context),
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: workoutData.numberofexrciseInworkout(workoutName),
          itemBuilder: (context, index) {
            final exercise = workoutData
                .getReleventWorkout(workoutName)
                .exercises[index];

            return ExerciseTile(
              exerciseName: exercise.name,
              weight: exercise.weight,
              reps: exercise.reps,
              sets: exercise.sets,
              isCompleted: exercise.isCompleted,
              onCheckBoxChanged: (val) => onCheckBoxChanged(context, exercise.name),
            );
          },
        ),
      ),
    );
  }
}
