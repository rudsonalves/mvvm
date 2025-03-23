import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvvm/domain/models/todo.dart';
import 'package:mvvm/routing/routes.dart';
import 'package:mvvm/ui/todo/todo_screen.dart';

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
    return Card(
      child: ListTile(
        onTap: () {
          context.push(Routes.todoDetails(todo.id!));
        },
        leading: Text(todo.id.toString()),
        title: Text(todo.name),
        trailing: IconButton(
          onPressed: () => onDeleteTodo(todo),
          icon: const Icon(Icons.delete, color: Colors.redAccent),
        ),
      ),
    );
  }
}
