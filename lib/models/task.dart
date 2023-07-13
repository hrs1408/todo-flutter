class Task {
  final int? id;
  final String task;
  final bool? isDone;

  Task({this.id, required this.task, this.isDone = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'isDone': isDone == false ? 0 : 1,
    };
  }
}
