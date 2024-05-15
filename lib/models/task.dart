class Task {
  String? task;
  DateTime? time;

  Task({this.task, this.time});

  // Factory constructor to create a Task object from a string
  factory Task.fromString(String task) {
    return Task(
      task: task,
      time: DateTime.now(),
    );
  }

  // Factory constructor to create a Task object from a map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      task: map['task'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  // Method to convert Task object to a map
  Map<String, dynamic> getMap() {
    return {
      'task': this.task,
      'time': this.time?.millisecondsSinceEpoch,
    };
  }
}
