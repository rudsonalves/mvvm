import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvvm/domain/models/todo.dart';
import 'package:mvvm/routing/routes.dart';
import 'package:mvvm/ui/todo/todo_screen.dart';

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
    return Card(
      child: ListTile(
        onTap: () {
          context.push(Routes.todoDetails(todo.id!));
        },
        leading: IconButton(
          onPressed: () => onDoneTodo(todo.copyWith(done: !todo.done)),
          icon: Icon(
            todo.done
                ? Icons.task_alt_rounded
                : Icons.radio_button_unchecked_rounded,
            color: todo.done ? Colors.greenAccent : null,
          ),
        ),
        // Checkbox(
        //   value: todo.done,
        //   onChanged: (value) {
        //     if (value == null) return;

        //     onDoneTodo(todo.copyWith(done: value));
        //   },
        // ),
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
}
