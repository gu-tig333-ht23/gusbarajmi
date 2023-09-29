// api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'task.dart';

class ApiService {
  final String baseUrl;
  final String apiKey;

  ApiService(this.baseUrl, this.apiKey);

  Future<void> fetchTasks() async {
    final response = await http.get(Uri.parse('$apiUrl/todos?key=$apiKey'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _homeList = data.map((task) => ToDo.fromJson(task)).toList();
      notifyListeners();
    }
  }

  Future<List<Task>> fetchTasks(String apiKey) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/todos?key=$apiKey'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<Task> tasks =
            jsonList.map((json) => Task.fromJson(json)).toList();
        return tasks;
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      throw Exception('Failed to load todos');
    }
  }

  Future<Task> addTask(apiKey, Task newTask) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newTask.toJson()), // Convert Task object to JSON
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final Task addedTask = Task.fromJson(jsonMap);
      return addedTask;
    } else {
      throw Exception('Failed to add a task');
    }
  }

  Future<Task> updateTask(apiKey, Task updatedTask) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/${updatedTask.id}?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedTask.toJson()), // Convert Task object to JSON
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final Task updatedTask = Task.fromJson(jsonMap);
      return updatedTask;
    } else {
      throw Exception('Failed to update a task');
    }
  }

  Future<void> deleteTask(apiKey, String taskId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/todos/$taskId?key=$apiKey'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete a task');
    }
  }
}
