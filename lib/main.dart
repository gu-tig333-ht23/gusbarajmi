// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_list.dart';
import 'filter_state.dart';
import 'task_provider.dart'; // Import the FilterState class

void main() async {
  // Initialize the TaskProvider and fetch tasks immediately
  final taskProvider = TaskProvider();
  await taskProvider.fetchTasks();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => taskProvider),
        ChangeNotifierProvider(create: (context) => FilterState()), // Provide FilterState
      ],
      child: TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      home: TodoList(),
    );
  }
}
