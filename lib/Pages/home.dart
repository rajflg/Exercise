import 'package:exercise/Pages/workoutpage.dart';
import 'package:exercise/data/workout_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initilizationworkoutlist();

  }

  final newWorkoutNameController = TextEditingController();

  void CreateNewWorkout(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Create new Workout"),
          content: TextField(
            controller: newWorkoutNameController,
          ),
          actions: [
            MaterialButton(
              onPressed: save,
              child: Text("save"),)
            ,MaterialButton(
              onPressed: back,
              child: Text("back"),)
          ],
        ));
  }
  void save(){
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addworkout(newWorkoutName);
    Navigator.pop(context);
    clear();
  }
  void back(){
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  void gotoworkoutpage(String workoutName){
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(workoutName: workoutName,)));
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("Workout tracker"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: CreateNewWorkout,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: value.getWorkoutList().length,
            itemBuilder: (context, index) => ListTile(
              title: Text(value.getWorkoutList()[index].name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () =>
                  gotoworkoutpage(value.getWorkoutList()[index].name)
              ),
            ) ),
      )
    );
  }
}
