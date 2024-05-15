import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task t = Task.fromString(_taskController.text);
    prefs.setString('task', json.encode(t.getMap()));
    //_taskController.text = "";
    _taskController.clear();
  }

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Task Manager"),
      ),
      body: const Center(child: Text("No task added yet")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => Container(
            padding: const EdgeInsets.all(10.0),
            //width: MediaQuery.of(context).size.width,
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
                          onTap: () => Navigator.of(context).pop()),
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
                        style: const ButtonStyle(
                            //minimumSize:
                            // MaterialStateProperty.all(const Size(200, 50)),
                            ),
                        child: const Text("RESET"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          saveData();
                        },
                        style: const ButtonStyle(
                            //minimumSize:
                            //MaterialStateProperty.all(const Size(200, 50)),
                            ),
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
