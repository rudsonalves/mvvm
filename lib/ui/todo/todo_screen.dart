import 'package:flutter/material.dart';

import 'package:mvvm/domain/models/todo.dart';
import 'package:mvvm/ui/todo/view_models/todo_view_model.dart';
import 'package:mvvm/ui/todo/components/add_todo_dialog.dart';
import 'package:mvvm/ui/todo/components/todo_list_view.dart';

typedef OnDeleteTodo = void Function(Todo todo);

class TodoScreen extends StatefulWidget {
  final TodoViewModel todoViewModel;

  const TodoScreen({super.key, required this.todoViewModel});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        centerTitle: true,
        elevation: 5,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add_rounded),
      ),
      body: ListenableBuilder(
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
              ),
        ),
      ),
    );
  }

  void _addTodo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddTodoDialog(todoView: widget.todoViewModel),
    );
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
