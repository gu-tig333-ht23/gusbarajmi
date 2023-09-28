//main.dart
import 'package:flutter/material.dart';
import 'todo_list.dart';

//Runs the app
void main() {
  runApp(TodoApp());
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
