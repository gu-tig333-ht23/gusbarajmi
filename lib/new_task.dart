import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task.dart';
import 'api_service.dart';

class NewTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _taskController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                hintText: 'Write your task here',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String taskTitle = _taskController.text;
                if (taskTitle.isNotEmpty) {
                  // Access the API service to add the new task
                  final apiService =
                      Provider.of<ApiService>(context, listen: false);
                  final newTask = Task(
                    id: '',
                    title: taskTitle,
                    done: false,
                  );

                  try {
                    await apiService.addTask(apiService.apiKey, newTask);
                    // Return to the previous screen with the new task object
                    Navigator.pop(context);
                  } catch (e) {
                    print('Error adding task: $e');
                  }
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
