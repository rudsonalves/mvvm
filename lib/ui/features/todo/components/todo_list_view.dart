import 'package:flutter/material.dart';

import '/domain/models/todo.dart';
import 'list_tile_todo.dart';
import '../todo_screen.dart';

class ListViewTodos extends StatelessWidget {
  final List<Todo> todos;
  final OnDeleteTodo onDeleteTodo;
  final OnDoneTodo onUpdateTodo;

  const ListViewTodos({
    super.key,
    required this.todos,
    required this.onDeleteTodo,
    required this.onUpdateTodo,
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const Center(child: Text('Nenhuma tarefa no momento...'));
    }

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder:
          (context, index) => ListTileTodo(
            todo: todos[index],
            onDeleteTodo: onDeleteTodo,
            onDoneTodo: onUpdateTodo,
          ),
    );
  }
}
