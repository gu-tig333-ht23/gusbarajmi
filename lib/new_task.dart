import 'package:flutter/material.dart';
import 'task.dart';

// Builds a page for new tasks
class NewTaskPage extends StatelessWidget {
  const NewTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller for input
    final taskController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text field with input controller
            TextField(
              controller: taskController,
              decoration: const InputDecoration(
                // Placeholder text
                hintText: 'Write your task here',
              ),
            ),
            const SizedBox(height: 20),
            // Button to add the new task and move back to homepage
            ElevatedButton(
              onPressed: () {
                String taskTitle = taskController.text;
                if (taskTitle.isNotEmpty) {
                  Task newTask =
                      Task(title: taskTitle, isCompleted: false); // Create the Task object
                  // Return the new task to the previous screen (TodoList)
                  Navigator.pop(context, newTask);
                }
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
