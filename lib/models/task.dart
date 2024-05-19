class Task {
  String? task;
  DateTime? time;
  bool isCompleted;

  Task({
    this.task,
    this.time,
    this.isCompleted = false,
  });

  factory Task.fromString(String task) {
    return Task(
      task: task,
      time: DateTime.now(),
      isCompleted: false,
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      task: map['task'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      isCompleted: map['isCompleted'] ?? false, // Default to false if null
    );
  }

  Map<String, dynamic> getMap() {
    return {
      'task': task,
      'time': time?.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
    };
  }
}
