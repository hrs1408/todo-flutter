import 'package:flutter/material.dart';
import 'package:fluttertodolist/screens/add_task_screen.dart';
import 'package:fluttertodolist/screens/main_screen.dart';

import 'models/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MainScreen.id,
      routes: {
        MainScreen.id: (_) => MainScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AddTaskScreen.id) {
          return MaterialPageRoute(
            builder: (context) {
              if (settings.arguments != null) {
                Task task = settings.arguments as Task;
                return AddTaskScreen(task);
              }
              return AddTaskScreen(Task(task: ''));
            },
          );
        }
        return null;
      },
    );
  }
}
