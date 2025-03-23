import 'package:flutter/material.dart';

import 'package:mvvm/ui/todo_details/view_models/todo_details_view_model.dart';

class TodoDetailsScreen extends StatefulWidget {
  final String id;
  final TodoDetailsViewModel todoDetailsViewModel;

  const TodoDetailsScreen({
    super.key,
    required this.todoDetailsViewModel,
    required this.id,
  });

  @override
  State<TodoDetailsScreen> createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: ListenableBuilder(
        listenable: widget.todoDetailsViewModel.load,
        builder: (context, child) {
          final load = widget.todoDetailsViewModel.load;

          if (load.running) {
            return const Center(child: CircularProgressIndicator());
          } else if (load.error) {
            return const Center(child: Text('DOcorreu um erro'));
          }

          return child!;
        },
        child: ListenableBuilder(
          listenable: widget.todoDetailsViewModel,
          builder: (context, _) {
            final todo = widget.todoDetailsViewModel.todo;

            return ListTile(leading: Text(todo.id!), title: Text(todo.name));
          },
        ),
      ),
    );
  }
}
