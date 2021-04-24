import 'dart:convert';

import 'package:todo_app/domain/task/task.dart';
import 'package:todo_app/domain/task/taskListSerializer.dart';

class TaskList {
  final String _name;
  List<Task> _tasks = [];
  final TasksListSerializer taskListSerializer;

  TaskList(this._name, this.taskListSerializer, [List<Task>? tasks]) {
    if (tasks != null)
      _tasks = tasks;
  }

  Task getTask(int index) {
    return _tasks[index];
  }

  List<Task> getTasks() {
    return _tasks;
  }

  void setTasks(List<Task> tacks) {
    _tasks = tacks;
  }

  String getName() {
    return _name;
  }

  void addTask(Task task) {
    _tasks.add(task);
  }

  void modifyTask(Task task, Task newTask) {
    int index = _tasks.lastIndexOf(task);
    if (index == -1)
      return;
    _tasks[index] = newTask;
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
  }

  void save() async {
    String jsonTasks = _toJson();
    await taskListSerializer.save(_name, jsonTasks);
  }

  Future<TaskList> load() async {
    String? tasksJson = await taskListSerializer.load(_name);
    if (tasksJson == null)
      throw Exception("Failed to load task list");
    setTasks(_fromJson(tasksJson));
    return this;
  }

  String _toJson() => jsonEncode(_tasks);

  List<Task> _fromJson(String json) {
    var taskList = jsonDecode(json) as List;
    return taskList.map((t)  => Task.fromJson(t)).toList();
  }
}