import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_list.dart';
import 'filter_state.dart';
import 'task_provider.dart';

void main() async {
  // Initialize the TaskProvider and fetch tasks immediately
  final taskProvider = TaskProvider();
  await taskProvider.fetchTasks();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => taskProvider),
        ChangeNotifierProvider(create: (context) => FilterState()),
      ],
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todo App',
      home: TodoList(),
    );
  }
}
