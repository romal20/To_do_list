import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_list/db/db_helper.dart';
import 'package:to_do_list/models/task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize tasks when the controller is ready
    getTasks();
  }

  Future<String> addTask({required Task task}) async {
    try {
      print("Adding task: ${task.toJson()}"); // Debug print
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      String id = await DbHelper.insert(task, userId);
      getTasks(); // Refresh task list after insertion
      print("Task added with id: $id"); // Debug print
      return id;
    } catch (e) {
      print("Error adding task: $e");
      throw e;
    }
  }

  /*void getTasks() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        List<Task> tasks = await DbHelper.query(userId);
        taskList.assignAll(tasks);
        print("Retrieved tasks: ${taskList.length}"); // Debug print
      } else {
        print("Error: User ID is empty.");
        // Handle the case where user ID is empty
      }
    } catch (e) {
      print("Error fetching tasks: $e");
      // Handle error appropriately, e.g., show error message or log it
    }
  }*/
  void getTasks() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        List<Task> tasks = await DbHelper.query(userId);
        taskList.assignAll(tasks);
        print("Retrieved tasks: ${taskList.length}"); // Debug print

        // Print all tasks
        /*for (var task in taskList) {
          printTaskDetails(task);
        }*/
      } else {
        print("Error: User ID is empty.");
        // Handle the case where user ID is empty
      }
    } catch (e) {
      print("Error fetching tasks: $e");
      // Handle error appropriately, e.g., show error message or log it
    }
  }

// Helper method to print task details
  /*void printTaskDetails(Task task) {
    print("Task ID: ${task.id}");
    print("Title: ${task.title}");
    print("Note: ${task.note}");
    print("Is Completed: ${task.isCompleted}");
    print("Date: ${task.date}");
    print("Start Time: ${task.startTime}");
    print("End Time: ${task.endTime}");
    print("Color: ${task.color}");
    print("Remind: ${task.remind}");
    print("Repeat: ${task.repeat}");
    print("-----");
  }
*/

  void deleteTask(Task task) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      print(FirebaseAuth.instance.currentUser?.uid);
      await DbHelper.delete(task, userId);
      getTasks(); // Refresh task list after deletion
    } catch (e) {
      print('Error deleting task: $e');
      // Handle error appropriately
    }
  }

  void markTaskCompleted(Task task) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      task.isCompleted = 1;
      await DbHelper.update(task, userId);
      getTasks(); // Refresh task list after update
    } catch (e) {
      print('Error marking task completed: $e');
      // Handle error appropriately
    }
  }
}
