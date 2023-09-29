import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task.dart';
import 'new_task.dart';
import 'api_service.dart';

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = context
        .read<ApiService>(); // Get the ApiService instance from the context

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: FutureBuilder<List<Task>>(
        // Use FutureBuilder to fetch and display tasks
        future: apiService
            .fetchTasks(apiService.apiKey), // Fetch tasks using the API key
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks available.'));
          } else {
            final tasks = snapshot.data!;

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: task.done,
                    onChanged: (bool? value) async {
                      // Update task completion status using ApiService
                      final updatedTask = await apiService.updateTask(
                        apiService.apiKey,
                        task.copyWith(done: value!),
                      );
                      // Replace the task with the updated task in the list
                      tasks[index] = updatedTask;
                    },
                  ),
                  title: Text(task.title),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () async {
                      // Delete task using ApiService
                      await apiService.deleteTask(apiService.apiKey, task.id);
                      // Remove the task from the list
                      tasks.removeAt(index);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTaskPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
