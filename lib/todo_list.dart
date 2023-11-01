import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'new_task.dart';
import 'filter_state.dart';
import 'task_provider.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final filterState = context.watch<FilterState>(); // Access FilterState

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              filterState.setFilter(value); // Update the filter state
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'All Tasks',
                child: Text('All Tasks'),
              ),
              const PopupMenuItem<String>(
                value: 'Finished',
                child: Text('Finished'),
              ),
              const PopupMenuItem<String>(
                value: 'Unfinished',
                child: Text('Unfinished'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Shows ${filterState.selectedFilter}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.tasks;
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks available.'));
          } else {
            //Build a listview of the tasks
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                // Apply the filter
                if (filterState.selectedFilter == 'All Tasks' ||
                    (filterState.selectedFilter == 'Finished' && task.isCompleted) ||
                    (filterState.selectedFilter == 'Unfinished' && !task.isCompleted)) {
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
                      icon: const Icon(Icons.delete),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final addedTask = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewTaskPage(),
            ),
          );
          if (addedTask != null) {
            await taskProvider.addTask(addedTask);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
