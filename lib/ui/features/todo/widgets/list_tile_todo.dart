import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/domain/models/todo.dart';
import '/routing/routes.dart';
import '../todo_screen.dart';

class ListTileTodo extends StatelessWidget {
  final Todo todo;
  final OnDeleteTodo onDeleteTodo;
  final OnDoneTodo onDoneTodo;

  const ListTileTodo({
    super.key,
    required this.todo,
    required this.onDeleteTodo,
    required this.onDoneTodo,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainerHigh,
      elevation: 1,
      child: ListTile(
        onTap: () {
          context.push(Routes.todoDetails(todo.id));
        },
        leading:
        // IconButton(
        //   onPressed: () => onDoneTodo(todo.copyWith(done: !todo.done)),
        //   icon: Icon(
        //     todo.done
        //         ? Icons.task_alt_rounded
        //         : Icons.radio_button_unchecked_rounded,
        //     color: todo.done ? Colors.green : null,
        //   ),
        // ),
        Checkbox(value: todo.done, onChanged: _toggleDone),
        title: Text(todo.name),
        subtitle:
            todo.description.trim().isNotEmpty ? Text(todo.description) : null,
        trailing: IconButton(
          onPressed: () => onDeleteTodo(todo),
          icon: const Icon(Icons.delete, color: Colors.redAccent),
        ),
      ),
    );
  }

  void _toggleDone(bool? value) {
    if (value == null) return;

    onDoneTodo(
      todo.copyWith(done: value, completedAt: value ? DateTime.now() : null),
    );
  }
}
