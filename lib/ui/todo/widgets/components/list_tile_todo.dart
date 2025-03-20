import 'package:flutter/material.dart';
import 'package:mvvm/domain/models/todo.dart';

class ListTileTodo extends StatelessWidget {
  final Todo todo;

  const ListTileTodo({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Text(todo.id.toString()), title: Text(todo.name));
  }
}
