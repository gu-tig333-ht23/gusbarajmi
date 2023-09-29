import 'package:flutter/material.dart';

import 'task.dart';
// Builds a page for new tasks
class NewTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Controller for input
    final _taskController = TextEditingController();

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
                hintText: 'Write your task here',
              ),
            ),
            SizedBox(height: 20),
            // Button to add the new task and move back to homepage
            ElevatedButton(
              onPressed: () {
                String taskTitle = _taskController.text;
                if (taskTitle.isNotEmpty) {
                  Task newTask = Task(
                      title: taskTitle,
                      isCompleted: false); // Create the Task object
                  // Return the new task to the previous screen (TodoList)
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
}
