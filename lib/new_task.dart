//new_task.dart

import 'package:flutter/material.dart';
import 'task.dart';

class NewTaskPage extends StatefulWidget {
  // Take list of tasks from the parent widget
  final List<Task> tasks;
  // Constructor that receives the list of tasks
  NewTaskPage(this.tasks);
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTaskPage> {
  // Controller for the text input
  TextEditingController _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  // Create a new task object using the input
                  Task newTask = Task(taskTitle, false);
                  _taskController.clear();
                  // Return to the previous screen with the new task object
                  Navigator.pop(context, newTask);
                }
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // Dispose of the text input controller
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}
