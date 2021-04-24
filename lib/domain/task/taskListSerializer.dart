
import 'package:todo_app/domain/task/task.dart';

abstract class TasksListSerializer {
  Future<void> save(String name, String tasksJson);
  Future<String?> load(String name);
}