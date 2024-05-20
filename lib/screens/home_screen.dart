import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _taskController;
  List<Task> _tasks = [];
  Task? _selectedTask;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
    _getTask();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task t = Task.fromString(_taskController.text);

    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);

    list.add(json.encode(t.getMap()));

    prefs.setString('task', json.encode(list));
    _taskController.clear();
    Navigator.of(context).pop();
    _getTask();
  }

  Future<void> _getTask() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);

    setState(() {
      _tasks = list.map((item) => Task.fromMap(json.decode(item))).toList();
    });
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = _tasks
        .where((task) => !task.isCompleted)
        .map((task) => json.encode(task.getMap()))
        .toList();
    await prefs.setString('task', json.encode(taskList));
  }

  void _toggleTaskCompletion(int index, bool? value) {
    setState(() {
      _tasks[index].isCompleted = value ?? false;
    });
    _saveTasks();
  }

  Future<void> _deleteTasks(Task taskToDelete) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tasks.remove(taskToDelete);
    List<String> taskList = _tasks
        .where((task) => !task.isCompleted)
        .map((task) => json.encode(task.getMap()))
        .toList();
    await prefs.setString('task', json.encode(taskList));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Task Manager"),
        actions: [
          IconButton(
            onPressed: () async {
              await _saveTasks();
              setState(() {
                print("Tasks saved successfully!");
              });
            },
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () async {
              if (_selectedTask != null) {
                await _deleteTasks(_selectedTask!);
                setState(() {
                  print("Task deleted successfully!");
                  _selectedTask = null;
                });
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text("No task added yet"))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index].task ?? ''),
                  subtitle: Text(_tasks[index].time?.toIso8601String() ?? ''),
                  trailing: Checkbox(
                    value: _tasks[index].isCompleted,
                    onChanged: (bool? value) {
                      _toggleTaskCompletion(index, value);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => Container(
            padding: const EdgeInsets.all(10.0),
            color: Colors.blue,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Add task"),
                      GestureDetector(
                        child: const Icon(Icons.close),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1.2),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.yellow),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Enter Text",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => _taskController.clear(),
                        style: const ButtonStyle(),
                        child: const Text("RESET"),
                      ),
                      ElevatedButton(
                        onPressed: saveData,
                        style: const ButtonStyle(),
                        child: const Text("Add"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
