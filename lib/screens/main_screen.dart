import 'package:flutter/material.dart';
import 'package:fluttertodolist/screens/add_task_screen.dart';

import '../database/taks_db.dart';
import '../models/task.dart';

class MainScreen extends StatefulWidget {
  static const id = 'main_screen';

  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Task> tasks = [];
  @override
  void initState() {
    getTasks();
    super.initState();
  }

  Future getTasks() async {
    final db = TaskDB();
    tasks = await db.getTasks();
    setState(() {});
  }

  Future deleteTask(int id) async {
    final db = TaskDB();
    await db.delete(id);
    tasks = await db.getTasks();
    await getTasks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Flutter todo app'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, AddTaskScreen.id);
          if (result == true) getTasks();
        },
        child:
            const IconButton.outlined(onPressed: null, icon: Icon(Icons.add)),
      ),
      body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(
                  tasks[index].task,
                  style: TextStyle(
                      decoration: tasks[index].isDone == true
                          ? TextDecoration.lineThrough
                          : null),
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 0,
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child: Text('Delete'),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Text('Done'),
                      )
                    ];
                  },
                  onSelected: (i) async {
                    if (i == 0) {
                      final result = await Navigator.pushNamed(
                          context, AddTaskScreen.id,
                          arguments: tasks[index]);
                      if (result == true) getTasks();
                    } else if (i == 1) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete todo?'),
                              content: const Text(
                                  'Are you sure you want to delete this todo?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      deleteTask(tasks[index].id!);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Yes')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No')),
                              ],
                            );
                          });
                    } else if (i == 2) {
                      final db = TaskDB();
                      final task = Task(
                          id: tasks[index].id,
                          task: tasks[index].task,
                          isDone: true);
                      await db.update(task);
                      getTasks();
                    }
                  },
                ));
          }),
    ));
  }
}
