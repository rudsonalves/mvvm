import 'package:flutter/material.dart';
import 'package:mvvm/ui/core/components/add_todo_dialog.dart';
import 'package:mvvm/ui/todo_details/components/todo_details_card.dart';

import 'package:mvvm/ui/todo_details/todo_details_view_model.dart';

class TodoDetailsScreen extends StatefulWidget {
  final TodoDetailsViewModel todoDetailsViewModel;

  const TodoDetailsScreen({super.key, required this.todoDetailsViewModel});

  @override
  State<TodoDetailsScreen> createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListenableBuilder(
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
            builder:
                (context, _) => TodoDetailsCard(
                  todo: widget.todoDetailsViewModel.todo,
                  editTodo: _editTodo,
                ),
          ),
        ),
      ),
    );
  }

  void _editTodo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AddTodoDialog(
            todo: widget.todoDetailsViewModel.todo,
            todoAction: widget.todoDetailsViewModel.upgrade,
          ),
    );
  }
}
