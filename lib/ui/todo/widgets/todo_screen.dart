import 'package:flutter/material.dart';
import 'package:mvvm/ui/todo/view_models/todo_view_model.dart';
import 'package:mvvm/ui/todo/widgets/components/todo_list_view.dart';

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
      appBar: AppBar(title: Text('Todo'), centerTitle: true, elevation: 5),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: Icon(Icons.add_rounded),
      ),
      body: ListenableBuilder(
        listenable: widget.todoViewModel.load,
        builder: (context, child) {
          if (widget.todoViewModel.load.running) {
            return Center(child: CircularProgressIndicator());
          } else if (widget.todoViewModel.load.error) {
            return Center(child: Text('Ocorreu um Erro.'));
          }

          return child!;
        },
        child: ListenableBuilder(
          listenable: widget.todoViewModel,
          builder:
              (context, _) => ListViewTodos(todos: widget.todoViewModel.todos),
        ),
      ),
    );
  }

  void _addTodo() {
    widget.todoViewModel.addTodo.execute('Novo Todo');
  }

  // void _showMessage() {
  //   SchedulerBinding.instance.addPersistentFrameCallback((_) {
  //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Ocorreu um erro. Tente mais tarde.')),
  //     );
  //   });
  // }
}
