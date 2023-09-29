//todo_list.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'task.dart';
import 'new_task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  String _apiKey =
      '85914d9c-8db3-4b90-8c07-25308ceb033a'; //API Key from /register
  String _baseUrl = 'https://todoapp-api.apps.k8s.gu.se'; // API URL

  List<Task> get tasks => _tasks;

  //Function for fetch tasks from the list within the API and refresh the local list
  Future<void> fetchTasks() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/todos?key=$_apiKey'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<Task> tasks =
            jsonList.map((json) => Task.fromJson(json)).toList();
        _tasks = tasks;
        notifyListeners();
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      throw Exception('Failed to load todos');
    }
  }

  //Function for adding new task to the list in the API
  Future<void> addTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/todos?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );

      if (response.statusCode == 200) {
        await fetchTasks(); // Fetch the updated list from the API.
      } else {
        throw Exception('Failed to add a task: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding task: $e');
      throw Exception('Failed to add a task');
    }
  }

  //Update done status of a task in the API
  Future<void> updateTask(Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/todos/${task.id}?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );

      if (response.statusCode == 200) {
        await fetchTasks(); // Fetch the updated list from the API.
      } else {
        throw Exception('Failed to update a task: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating task: $e');
      throw Exception('Failed to update a task');
    }
  }

  //Delete a task from the list in the API
  Future<void> deleteTask(String taskId) async {
    try {
      final response =
          await http.delete(Uri.parse('$_baseUrl/todos/$taskId?key=$_apiKey'));

      if (response.statusCode == 200) {
        await fetchTasks(); // Fetch the updated list from the API.
      } else {
        throw Exception('Failed to delete a task: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting task: $e');
      throw Exception('Failed to delete a task');
    }
  }
}

class TodoList extends StatelessWidget {
  String selectedFilter = 'All Tasks';

  TodoList({super.key}); // Initialize with the default filter

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    // Call fetchTasks to populate the local task list
    taskProvider.fetchTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        actions: [
          //Button for filtering
          PopupMenuButton<String>(
            onSelected: (value) {
              selectedFilter = value;
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'All Tasks',
                child: Text('All Tasks'),
              ),
              PopupMenuItem<String>(
                value: 'Finished',
                child: Text('Finished'),
              ),
              PopupMenuItem<String>(
                value: 'Unfinished',
                child: Text('Unfinished'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Shows $selectedFilter",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.tasks;
          if (tasks.isEmpty) {
            return Center(child: Text('No tasks available.'));
          } else {
            //Build a listview of the tasks
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                // Apply the filter
                if (selectedFilter == 'All Tasks' ||
                    (selectedFilter == 'Finished' && task.isCompleted) ||
                    (selectedFilter == 'Unfinished' && !task.isCompleted)) {
                  return ListTile(
                    // Checkbox with update function
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (bool? value) async {
                        task.isCompleted = value!;
                        await taskProvider.updateTask(task);
                      },
                    ),
                    title: Text(task.title),
                    trailing: IconButton(
                      // Delete button with delete function
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () async {
                        await taskProvider.deleteTask(task.id);
                      },
                    ),
                  );
                } else {
                  // Return an empty container if the task doesn't match the filter
                  return Container();
                }
              },
            );
          }
        },
      ),
      // Add task button with navigator to new page
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final addedTask = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTaskPage(),
            ),
          );
          if (addedTask != null) {
            await taskProvider.addTask(addedTask);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
