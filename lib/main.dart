import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:todo_app/domain/task/task.dart';
import 'package:todo_app/domain/task/taskActions.dart';
import 'package:todo_app/domain/task/taskList.dart';
import 'package:todo_app/infra/task/taskListSerializerImpl.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: 'Todo List', home: new TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _TodoListState();
  }
}

class _TodoListState extends State<TodoList> {
  TaskList taskList = TaskList("main task", TaskListSerializerImpl());

  final TextEditingController _taskNameTextFieldController = TextEditingController();
  final TextEditingController _taskDescriptionTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMainTask();
  }

  void _loadMainTask() {
    try {
      setState(() {
        taskList.load();
      });
    } catch (Exception) {
      debugPrint("Failed to load tasks!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Todo List')),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayAddTaskDialog(context),
        tooltip: 'Add new task',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoList() {
    return new ListView(children: _getTodoListItems());
  }

  List<Widget> _getTodoListItems() {
    List<Widget> taskItems = [];

    for (Task task in taskList.getTasks()) {
      taskItems.add(_buildTaskItem(task));
    }

    return taskItems;
  }

  Widget _buildTaskItem(Task task) {
    return Card(
      child: ListTile(
        title: Text(
            task.name,
            style: TextStyle(fontWeight: FontWeight.bold)
        ),
        trailing: PopupMenuButton<TaskActions>(
          onSelected: (TaskActions action) => handleItemPopupMenuSelection(action, task),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<TaskActions>> [
            const PopupMenuItem<TaskActions>(
                value: TaskActions.Modify,
                child: Text('Modify'),
            ),
            const PopupMenuItem<TaskActions>(
                value: TaskActions.Delete,
                child: Text('Delete', style: TextStyle(color: Colors.red),)
            )
          ]
        ),
      )
    );
  }

  void handleItemPopupMenuSelection(TaskActions action, Task task) {
    switch (action) {
      case TaskActions.Modify:
        break;
      case TaskActions.Delete:
        deleteTaskItem(task);
        break;
      default:
        break;
    }
  }

  void deleteTaskItem(Task task) {
    setState(() {
      taskList.deleteTask(task);
      taskList.save();
    });
  }

  Future<void> _displayAddTaskDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add a New Task'),
            content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                Text(
                  'Task name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                    controller: _taskNameTextFieldController,
                    decoration: const InputDecoration(hintText: 'Task name'),
                    maxLength: 50,
                    maxLines: 1),
                Text(
                  'Task description',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                    controller: _taskDescriptionTextFieldController,
                    decoration: const InputDecoration(hintText: 'Task description (optional)')),
              ]),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('ADD'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addTask(_taskNameTextFieldController.text, _taskDescriptionTextFieldController.text);
                  }),
            ],
          );
        });
  }

  void _addTask(String title, String description) {
    setState(() {
      taskList.addTask(Task(title, description));
      taskList.save();
    });

    _taskNameTextFieldController.clear();
    _taskDescriptionTextFieldController.clear();
  }
}
