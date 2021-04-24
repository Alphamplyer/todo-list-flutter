
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/domain/task/task.dart';

class TaskDialog extends StatefulWidget {
  final TaskDialogCallback onSubmit;
  final Text actionText;

  TaskDialog({
    Key? key,
    required this.actionText,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaskDialogState();
  }
}

typedef TaskDialogCallback(Task task);

class TaskDialogState extends State<TaskDialog> {

  final TextEditingController _taskNameTextFieldController = TextEditingController();
  final TextEditingController _taskDescriptionTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              decoration: const InputDecoration(hintText: 'Task description (optional)'),
              maxLength: 2000
          ),
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
            child: widget.actionText,
            onPressed: () {
              Navigator.of(context).pop();
              widget.onSubmit(Task(
                  _taskNameTextFieldController.text,
                  _taskDescriptionTextFieldController.text
              ));
            }),
      ],
    );
  }
}