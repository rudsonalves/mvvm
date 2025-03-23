import 'package:flutter/material.dart';
import 'package:mvvm/ui/todo/view_models/todo_view_model.dart';

class AddTodoDialog extends StatefulWidget {
  final TodoViewModel todoView;

  const AddTodoDialog({super.key, required this.todoView});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicione nova Tarefa'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 12),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text('Tarefa'),
                  hintText: 'Entre a nova Tarefa',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Preencha o campo Tarefa';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton.icon(
          onPressed: _cancelTodo,
          label: const Text('Cancelar'),
          icon: const Icon(Icons.cancel),
        ),
        FilledButton.icon(
          onPressed: _addTodo,
          label: const Text('Salvar'),
          icon: ListenableBuilder(
            listenable: widget.todoView.addTodo,
            builder: (context, _) {
              if (!widget.todoView.addTodo.running) {
                return const Icon(Icons.add);
              }
              return const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _addTodo() async {
    if (widget.todoView.addTodo.running) return;

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      await widget.todoView.addTodo.execute(nameController.text.trim());
      if (widget.todoView.addTodo.completed) {
        if (mounted) Navigator.pop(context);
      }
      if (widget.todoView.addTodo.error) {
        if (mounted) {
          await showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Erro'),
                  content: const Text(
                    'Desculpe. Ocorreu um erro ao criar uma nova tarefa. Tente mais tarde',
                  ),
                  backgroundColor: Colors.red.withValues(alpha: .75),
                  actions: [
                    FilledButton.icon(
                      onPressed: _cancelTodo,
                      label: const Text('Cancelar'),
                      icon: const Icon(Icons.cancel),
                    ),
                  ],
                ),
          );
        }
        if (mounted) Navigator.pop(context);
      }
    }
  }

  void _cancelTodo() => Navigator.pop(context);
}
