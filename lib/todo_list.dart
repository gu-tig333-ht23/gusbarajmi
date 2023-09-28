import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task.dart';
import 'new_task.dart';

class TaskProvider extends ChangeNotifier {
  // List to store tasks
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;
  // Add task function
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  // Remove task function
  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  // Update task completion status
  void updateTaskCompletion(int index, bool isCompleted) {
    _tasks[index].isCompleted = isCompleted;
    notifyListeners();
  }
}

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Context.watch to listen to changes
    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      // Build a list of the tasks to display
      body: ListView.builder(
        itemCount: taskProvider.tasks.length,
        // Build an item from current index task
        itemBuilder: (context, index) {
          final task = taskProvider.tasks[index];
          return ListTile(
            // Checkbox for task completion
            leading: Checkbox(
              value: task.isCompleted,
              // Update task completion status
              onChanged: (bool? value) {
                taskProvider.updateTaskCompletion(index, value!);
              },
            ),
            // Displays Task Title
            title: Text(task.title),
            // Delete button
            trailing: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                taskProvider.removeTask(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to NewTaskPage
          final addedTask = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTaskPage(),
            ),
          );
          // Add the new task to the list
          if (addedTask != null) {
            taskProvider.addTask(addedTask);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
