import 'package:flutter/material.dart';
import 'package:mvvm/domain/models/todo.dart';
import 'package:mvvm/ui/todo/widgets/todo_screen.dart';

class ListTileTodo extends StatelessWidget {
  final Todo todo;
  final OnDeleteTodo onDeleteTodo;

  const ListTileTodo({
    super.key,
    required this.todo,
    required this.onDeleteTodo,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(todo.id.toString()),
      title: Text(todo.name),
      trailing: IconButton(
        onPressed: () => onDeleteTodo(todo),
        icon: Icon(Icons.delete, color: Colors.redAccent),
      ),
    );
  }
}
