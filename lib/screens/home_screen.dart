import 'package:flutter/material.dart';

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                      child: const Text("RESET"),
                      onPressed: () => print("reset pressed"),
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(200, 50)),
                      ),
                    ),
                    //SizedBox(width:20),
                    ElevatedButton(
                      child: const Text("Add"),
                      onPressed: () => print("Add pressed"),
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(200, 50)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
