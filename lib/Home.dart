import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timetracker/TimeTracker.dart';
import 'package:timetracker/controllers/task_controller.dart';
import 'package:timetracker/controllers/time_controller.dart';

class Home extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  final StopwatchController stopwatchController =
      Get.put(StopwatchController());
  final TextEditingController _textController = TextEditingController();

  void addTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Enter task description',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color.fromARGB(255, 78, 144, 197)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _textController.clear();
              },
            ),
            TextButton(
              child: const Text(
                'Add',
                style: TextStyle(color: Color.fromARGB(255, 78, 144, 197)),
              ),
              onPressed: () {
                taskController.addTask(_textController.text);
                _textController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    stopwatchController.loadSavedTimes();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
      ),
      body: Obx(() => (taskController.tasks.isEmpty)
          ? Center(
              heightFactor: 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Image.asset(
                      "assets/images/add_task.png",
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Go ahead and add a new task",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            )
          : Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.separated(
                  itemCount: taskController.tasks.length,
                  itemBuilder: (context, index) {
                    Task task = taskController.tasks[index];
                    return Obx(() => GestureDetector(
                          onTap: () {
                            taskController.setCurrentTask(index);
                            Get.to(Timetracker());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 151, 197, 234),
                              borderRadius: BorderRadius.circular(
                                  8.0), // Adjust the radius as needed
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                      0.2), // Shadow color with opacity
                                  offset: const Offset(
                                      0, 4), // Horizontal and vertical offset
                                  blurRadius: 8.0, // Blur radius for the shadow
                                ),
                              ],
                            ),
                            child: ListTile(
                              tileColor: Colors
                                  .transparent, // Ensure this matches the Container background
                              title: Text(
                                task.title.value,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: task.isCompleted.value
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),

                              trailing: Obx(
                                () => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("total time:"),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    // stopwatchController.savedTimes.isNotEmpty
                                    //     ? Text(stopwatchController.savedTimes[
                                    //         stopwatchController
                                    //                 .savedTimes.length -
                                    //             1])
                                         Text(""),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    const Text("last date:"),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    // stopwatchController.savedDates.isNotEmpty
                                    //     ? Text(stopwatchController.savedDates[
                                    //         stopwatchController
                                    //                 .savedDates.length -
                                    //             1])
                                        Text(""),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    Checkbox(
                                      value: task.isCompleted.value,
                                      onChanged: (_) =>
                                          taskController.toggleTask(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                "Delete Task?",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 78, 144, 197)),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    taskController
                                                        .deleteTask(index);
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text(
                                                    "No",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 78, 144, 197)),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ));
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 12,
                  ),
                ),
              ),
            )),
      floatingActionButton: MaterialButton(
        onPressed: () => addTask(context),
        child: Container(
          width: 300,
          height: 60,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 63, 158, 235),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              const BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 5.0,
              )
            ],
          ),
          child: const Center(
            child: Text(
              "NEW TASK TO BE TRACKED",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
