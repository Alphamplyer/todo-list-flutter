import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:todo_app/domain/task/task.dart';
import 'package:todo_app/domain/task/taskActions.dart';
import 'package:todo_app/domain/task/taskList.dart';
import 'package:todo_app/infra/task/taskListSerializerImpl.dart';
import 'package:todo_app/view/widget/taskDialog.dart';

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
      title: Text(task.name, style: TextStyle(fontWeight: FontWeight.bold)),
      trailing: PopupMenuButton<TaskActions>(
          onSelected: (TaskActions action) => handleItemPopupMenuSelection(context, action, task),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<TaskActions>>[
                const PopupMenuItem<TaskActions>(
                  value: TaskActions.Modify,
                  child: Text('Modify'),
                ),
                const PopupMenuItem<TaskActions>(
                    value: TaskActions.Delete,
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ))
              ]),
    ));
  }

  void handleItemPopupMenuSelection(BuildContext context, TaskActions action, Task task) {
    switch (action) {
      case TaskActions.Modify:
        modifyTaskItem(context, task);
        break;
      case TaskActions.Delete:
        _deleteTask(task);
        break;
      default:
        break;
    }
  }

  void modifyTaskItem(BuildContext context, Task task) async{
    await _displayModifyTaskDialog(context, task);

  }

  void _deleteTask(Task task) {
    setState(() {
      taskList.deleteTask(task);
      taskList.save();
    });
  }

  Future<void> _displayAddTaskDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return TaskDialog(
              onSubmit: _addTask,
              actionText: const Text(
                'ADD',
                style: TextStyle(fontWeight: FontWeight.bold),
              ));
        });
  }

  void _addTask(Task task) {
    setState(() {
      taskList.addTask(task);
      taskList.save();
    });
  }

  Future<void> _displayModifyTaskDialog(BuildContext context, Task task) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return TaskDialog(
              onSubmit: (newTask) {
                _modifyTask(task, newTask);
              },
              actionText: const Text(
                'MODIFY',
                style: TextStyle(fontWeight: FontWeight.bold),
              ));
        });
  }

  void _modifyTask(Task task, Task newTask) {
    setState(() {
      taskList.modifyTask(task, newTask);
      taskList.save();
    });
  }
}
