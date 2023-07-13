import 'package:flutter/material.dart';
import 'package:fluttertodolist/database/taks_db.dart';

import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  static const id = 'add_task_screen';

  final Task task;

  AddTaskScreen(this.task);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _taskController = TextEditingController();
  bool _inSync = false;
  String _taskError = '';

  @override
  void initState() {
    Task task = widget.task;
    if (task.task != '') {
      _taskController.text = task.task;
    }
    super.initState();
  }

  void addTask() async {
    if (_taskController.text.isEmpty) {
      setState(() {
        _taskError = 'Task cannot be empty';
      });
      return;
    }
    setState(() {
      _taskError = '';
      _inSync = true;
    });

    final db = TaskDB();
    final task = Task(task: _taskController.text.trim());
    await db.insert(task);
    setState(() {
      _inSync = false;
    });
    Navigator.pop(context, true);
  }

  void updateTask(int id) async {
    if (_taskController.text.isEmpty) {
      setState(() {
        _taskError = 'Task cannot be empty';
      });
      return;
    }
    setState(() {
      _taskError = '';
      _inSync = true;
    });
    final db = TaskDB();
    final task = Task(id: id, task: _taskController.text.trim());
    await db.update(task);
    setState(() {
      _inSync = false;
    });
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Add task'),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                !_inSync
                    ? IconButton(
                        icon: const Icon(Icons.done),
                        onPressed: () {
                          widget.task.task == ''
                              ? addTask()
                              : updateTask(widget.task.id!);
                        },
                      )
                    : const Icon(Icons.refresh),
              ],
              elevation: 0.0,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
            ),
            body: WillPopScope(
              onWillPop: () async {
                if (!_inSync) return true;
                return false;
              },
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                        labelText: 'Task',
                        errorText: _taskError,
                        border: const OutlineInputBorder()),
                  )),
            )));
  }
}
