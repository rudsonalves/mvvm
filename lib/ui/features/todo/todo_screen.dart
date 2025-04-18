import 'package:flutter/material.dart';

import '/ui/core/themes/app_theme_inherited.dart';
import '/domain/models/todo.dart';
import 'todo_view_model.dart';
import '../../core/widgets/edit_todo_dialog.dart';
import 'widgets/todo_list_view.dart';

typedef OnDeleteTodo = void Function(Todo todo);
typedef OnDoneTodo = void Function(Todo todo);

class TodoScreen extends StatefulWidget {
  final TodoViewModel todoViewModel;

  const TodoScreen({super.key, required this.todoViewModel});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    final AppThemeInherited appTheme = AppThemeInherited.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        centerTitle: true,
        elevation: 5,
        actions: [
          IconButton(
            onPressed: appTheme.toggleTheme,
            icon: Icon(appTheme.isDark ? Icons.dark_mode : Icons.light_mode),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListenableBuilder(
          listenable: widget.todoViewModel.load,
          builder: (context, child) {
            if (widget.todoViewModel.load.running) {
              return const Center(child: CircularProgressIndicator());
            } else if (widget.todoViewModel.load.error) {
              return const Center(child: Text('Ocorreu um Erro.'));
            }

            return child!;
          },
          child: ListenableBuilder(
            listenable: widget.todoViewModel,
            builder:
                (context, _) => ListViewTodos(
                  todos: widget.todoViewModel.todos,
                  onDeleteTodo: _onDeleteTodo,
                  onUpdateTodo: _onUpdateTodo,
                ),
          ),
        ),
      ),
    );
  }

  void _addTodo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => EditTodoDialog(command: widget.todoViewModel.addTodo),
    );
  }

  Future<void> _onUpdateTodo(Todo todo) async {
    await widget.todoViewModel.updateTodo.execute(todo);
  }

  Future<void> _onDeleteTodo(Todo todo) async {
    await widget.todoViewModel.deleteTodo.execute(todo);

    if (widget.todoViewModel.deleteTodo.completed) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tarefa "${todo.name}" removida com sucesso.'),
            backgroundColor: Colors.lightGreen,
          ),
        );
      }
    } else if (widget.todoViewModel.deleteTodo.error) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro na remoção da terefa "${todo.name}". Tente mais tarde',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
