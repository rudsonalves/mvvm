import 'package:flutter/material.dart';
import 'package:mvvm/domain/models/todo.dart';

class TodoEdit extends StatelessWidget {
  const TodoEdit({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(todo.name, style: const TextStyle(fontSize: 18)),
    );
  }
}
