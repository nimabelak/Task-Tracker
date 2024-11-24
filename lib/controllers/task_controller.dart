import 'package:get/get.dart';

class Task {
  final RxString title;
  final RxBool isCompleted;

  Task({required String title, bool isCompleted = false})
      : title = RxString(title),
        isCompleted = RxBool(isCompleted);
}

class TaskController extends GetxController {
  var isCompleted = false.obs;
  var currentTask = "".obs;
  var taskID = 0.obs;

  final RxList<Task> tasks = <Task>[].obs;

  void addTask(String title) {
    if (title.isNotEmpty) {
      tasks.add(Task(title: title));
    }
  }

  void toggleTask(int index) {
    tasks[index].isCompleted.value = !tasks[index].isCompleted.value;
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
  }

  void setCurrentTask(int index) {
    currentTask.value = tasks[index].title.value;
  }

  void saveTask() async {}
}
