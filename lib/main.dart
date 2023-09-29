// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_list.dart';
import 'api_service.dart';

void main() {
  runApp(
    Provider<ApiService>(
      create: (_) => ApiService(
        'https://todoapp-api.apps.k8s.gu.se/',
        "f7d8854c-fc73-4a6f-a5db-85e5095ec22d",
      ),
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
