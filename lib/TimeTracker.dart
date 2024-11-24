import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timetracker/controllers/task_controller.dart';
import 'package:timetracker/controllers/time_controller.dart';

class Timetracker extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${taskController.currentTask.value} Time Tracker'),
      ),
      body: StopwatchWidget(),
    );
  }
}

class StopwatchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StopwatchController controller = Get.put(StopwatchController());
    controller.loadSavedTimes();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Text(
                  controller.displayTime,
                  style: const TextStyle(
                      fontSize: 72, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.startStop();
                    controller.saveTimesToLocalStorage();
                  },
                  child: Obx(() => Text(
                        controller.isRunning ? 'Stop' : 'Start',
                        style: const TextStyle(fontSize: 24),
                      )),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => controller.saveTime(),
                  child: const Text('Save', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    controller.reset();
                    controller.saveTimesToLocalStorage();
                  },
                  child: const Text('Reset', style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  itemCount: controller.savedTimes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                "Remove Entry?",
                                style: TextStyle(fontSize: 16),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 78, 144, 197)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    controller.removeDate(index);
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    "No",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 78, 144, 197)),
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 151, 197, 234),
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the radius as needed
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                  0.2), // Shadow color with opacity
                              offset: Offset(
                                  0, 4), // Horizontal and vertical offset
                              blurRadius: 8.0, // Blur radius for the shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Text(
                            "${index + 1}",
                            style: TextStyle(fontSize: 18),
                          ),
                          title: Text(
                            controller.savedTimes[index],
                            style: const TextStyle(fontSize: 24),
                          ),
                          trailing: Text(
                            controller.savedDates[index],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
