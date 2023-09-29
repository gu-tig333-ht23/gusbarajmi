import 'package:flutter/material.dart';
import 'task.dart';
import 'new_task.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // List to store tasks
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      // Build a list of the tasks to display
      body: ListView.builder(
        itemCount: tasks.length,
        // Build an item from current index task
        itemBuilder: (context, index) {
          return ListTile(
            // Checkbox for task completion
            leading: Checkbox(
              value: tasks[index].isCompleted,
              // Update task completion status
              onChanged: (bool? value) {
                if (value != null) {
                  setState(() {
                    tasks[index].isCompleted = value;
                  });
                }
              },
            ),
            // Displays Task Title
            title: Text(tasks[index].title),
            // Delete button
            trailing: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                setState(() {
                  tasks.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to NewTaskPage
          final addedTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewTaskPage(tasks)),
          );
          // Add the new task to the list
          if (addedTask != null) {
            setState(() {
              tasks.add(addedTask);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
