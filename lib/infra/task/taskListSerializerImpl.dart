
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/domain/task/task.dart';
import 'package:todo_app/domain/task/taskList.dart';
import 'package:todo_app/domain/task/taskListSerializer.dart';

class TaskListSerializerImpl implements TasksListSerializer {

  @override
  Future<String?> load(String name) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(name);
  }

  @override
  Future<void> save(String name, String tasksJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(name, tasksJson);
  }
}