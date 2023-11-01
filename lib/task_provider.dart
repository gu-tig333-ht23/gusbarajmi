import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  final String _apiKey = 'e59cbe13-ad3d-4077-926a-132a286a96ad'; //API Key from /register
  final String _baseUrl = 'https://todoapp-api.apps.k8s.gu.se'; // API URL

  List<Task> get tasks => _tasks;

  //Function for fetching tasks from the list within the API and refresh the local list
  Future<void> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/todos?key=$_apiKey'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<Task> tasks = jsonList.map((json) => Task.fromJson(json)).toList();
        _tasks = tasks;
        notifyListeners();
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
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
      throw Exception('Failed to update a task');
    }
  }

  //Delete a task from the list in the API
  Future<void> deleteTask(String taskId) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/todos/$taskId?key=$_apiKey'));

      if (response.statusCode == 200) {
        await fetchTasks(); // Fetch the updated list from the API.
      } else {
        throw Exception('Failed to delete a task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete a task');
    }
  }
}
