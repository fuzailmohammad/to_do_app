import 'package:flutter/material.dart';
import 'package:to_do_app/to_do_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'To-Do List App',
      debugShowCheckedModeBanner: false,
      home: TodoListScreen(),
    );
  }
}

