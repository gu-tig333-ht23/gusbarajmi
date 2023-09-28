//new_task.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/todo_list.dart';
import 'task.dart';

class NewTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _taskController = TextEditingController();
    // Dispose of the controller when the widget is disposed
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _taskController.dispose();
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text field with input controller
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                // Placeholder text
                hintText: 'Write your task here',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save the input to a string (taskTitle)
                String taskTitle = _taskController.text;
                if (taskTitle.isNotEmpty) {
                  // Access the TaskProvider and add the new task
                  final taskProvider =
                      Provider.of<TaskProvider>(context, listen: false);
                  taskProvider.addTask(
                    Task(taskTitle, false),
                  );
                  _taskController.clear();
                  // Return to the previous screen with the new task object
                  Navigator.pop(context);
                }
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
