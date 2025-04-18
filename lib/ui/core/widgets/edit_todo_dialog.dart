import 'package:flutter/material.dart';

import '/domain/models/todo.dart';
import '/utils/commands/commands.dart';

class EditTodoDialog extends StatefulWidget {
  final Todo? todo;
  final Command1<Todo, Todo> todoAction;

  const EditTodoDialog({super.key, this.todo, required this.todoAction});

  @override
  State<EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  final _nameController = TextEditingController();
  final _descriptionConreoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.todo != null) {
      _nameController.text = widget.todo!.name;
      _descriptionConreoller.text = widget.todo!.description;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionConreoller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.todo != null ? 'Editar Tarefa' : 'Adicionar Tarefa'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 12),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  label: Text('Título'),
                  hintText: 'Título da tarefa',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: _validateTitle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 12),
              child: TextFormField(
                controller: _descriptionConreoller,
                minLines: 3,
                maxLines: null,
                decoration: const InputDecoration(
                  label: Text('Descrição'),
                  hintText: 'Descrição da tarefa',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: _validateDescription,
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
            listenable: widget.todoAction,
            builder: (context, _) {
              if (!widget.todoAction.running) {
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

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Adicione uma descrição';
    }
    return null;
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha um título para a Tarefa';
    }
    return null;
  }

  Future<void> _addTodo() async {
    if (widget.todoAction.running) return;

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final newTodo =
          widget.todo?.copyWith(
            name: _nameController.text.trim(),
            description: _descriptionConreoller.text.trim(),
          ) ??
          Todo(
            name: _nameController.text.trim(),
            description: _descriptionConreoller.text.trim(),
          );

      await widget.todoAction.execute(newTodo);
      if (widget.todoAction.completed) {
        if (mounted) Navigator.pop(context);
      }
      if (widget.todoAction.error) {
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
