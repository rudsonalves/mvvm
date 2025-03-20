import 'package:flutter/material.dart';
import 'package:mvvm/domain/models/todo.dart';
import 'package:mvvm/ui/todo/widgets/components/list_tile_todo.dart';

class ListViewTodos extends StatelessWidget {
  final List<Todo> todos;

  const ListViewTodos({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return Center(child: Text('Nenhuma tarefa no momento...'));
    }

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) => ListTileTodo(todo: todos[index]),
    );
  }
}
