import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/task.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  TodoListScreenState createState() => TodoListScreenState();
}

class TodoListScreenState extends State<TodoListScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: const Text('To-Do List'),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 20,color: Colors.white,),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index].title),
            trailing: Checkbox(
              value: tasks[index].isComplete,
              onChanged: (value) {
                setState(() {
                  tasks[index].isComplete = value!;
                  _saveTasks();
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    String newTaskTitle = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            onChanged: (value) {
              newTaskTitle = value;
            },
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tasks.add(Task(newTaskTitle, false));
                  _saveTasks();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasksJsonList =
    tasks.map((task) => taskToJson(task)).toList();
    prefs.setStringList('tasks', tasksJsonList);
  }

  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tasksJsonList = prefs.getStringList('tasks');

    if (tasksJsonList != null) {
      setState(() {
        tasks = tasksJsonList.map((json) => taskFromJson(json)).toList();
      });
    }
  }

  String taskToJson(Task task) {
    return '{"title": "${task.title}", "isComplete": ${task.isComplete}}';
  }

  Task taskFromJson(String json) {
    Map<String, dynamic> taskMap = Map<String, dynamic>.from(
        Map<String, dynamic>.from(jsonDecode(json)));
    return Task(taskMap['title'], taskMap['isComplete']);
  }
}