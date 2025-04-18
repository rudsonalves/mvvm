import 'package:flutter/material.dart';

import '/domain/models/todo.dart';
import 'details_row.dart';

class TodoDetailsCard extends StatelessWidget {
  final Todo todo;
  final void Function() editTodo;

  const TodoDetailsCard({
    super.key,
    required this.todo,
    required this.editTodo,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: editTodo,
      child: Card(
        color: colorScheme.surfaceContainerHigh,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 4,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      todo.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.edit, color: Colors.green),
                ],
              ),
              const Divider(),
              DetailsRow(label: 'Descrição', value: todo.description),
              DetailsRow(label: 'Criado em', value: todo.createdAt.toString()),
              DetailsRow(
                label: 'Concluído',
                value:
                    '${todo.done ? todo.completedAt?.toLocal().toString() : 'Ainda em aberto'}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
