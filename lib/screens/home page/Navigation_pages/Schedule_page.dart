import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class Schedule_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black45,
     // title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TodoList(),
    );
  }
}

class Todo {
  String description;
  DateTime timestamp;
  bool isCompleted;

  Todo({
    required this.description,
    required this.timestamp,
    this.isCompleted = false,
  });

  // Convert a Todo object to a Map for serialization
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // Convert a Map to a Todo object
  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(
      description: map['description'],
      timestamp: DateTime.parse(map['timestamp']),
      isCompleted: map['isCompleted'],
    );
  }

  // Convert Todo to a JSON string
  String toJson() => jsonEncode(toMap());

  // Convert JSON string to Todo object
  static Todo fromJson(String json) {
    return fromMap(jsonDecode(json));
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks from SharedPreferences
  _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> tasksString = prefs.getStringList('tasks') ?? [];
    setState(() {
      _tasks =
          tasksString.map((taskString) => Todo.fromJson(taskString)).toList();
    });
  }

  // Save tasks to SharedPreferences
  _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tasksString = _tasks.map((task) => task.toJson()).toList();
    prefs.setStringList('tasks', tasksString);
  }

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tasks.add(Todo(
            description: _controller.text,
            timestamp: DateTime.now())); // Add task with current timestamp
      });
      _controller.clear();
      _saveTasks(); // Save the updated list
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks(); // Save the updated list
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    _saveTasks(); // Save the updated list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule Your Places \n                & Times',
          style: TextStyle(fontWeight: FontWeight.w500, shadows: [
            Shadow(color: Colors.black12, blurRadius: 5, offset: Offset(3, 3))
          ],fontFamily: ''),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (bool? value) {
                            _toggleTaskCompletion(index);
                          },
                        ),
                        title: Text(
                          task.description,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(
                          'Added on: ${DateFormat('dd-MM-yyyy – hh:mm a').format(task.timestamp)}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_rounded,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () => _deleteTask(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.black45,
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Make notes...' ,labelStyle: TextStyle(
                        fontSize: 15,color: Colors.grey
                      ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.circular(20)
                        )
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_rounded,
                      size: 40,
                    ),
                    onPressed: _addTask,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
