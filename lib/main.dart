//main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_list.dart';

//Runs the app
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  @override
  // Builds the app with the TodoList widget as the home screen
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      home: TodoList(),
    );
  }
}
