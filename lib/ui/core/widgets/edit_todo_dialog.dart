import 'package:flutter/material.dart';
import 'package:mvvm/utils/commands/commands.dart';

import '/domain/models/todo.dart';

class EditTodoDialog extends StatefulWidget {
  final Todo? todo;
  final Command1<Todo, Todo> command;

  const EditTodoDialog({super.key, this.todo, required this.command});

  @override
  State<EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  final _nameController = TextEditingController();
  final _descriptionConreoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final Command1<Todo, Todo> _command;

  @override
  void initState() {
    _command = widget.command;

    if (widget.todo != null) {
      _nameController.text = widget.todo!.name;
      _descriptionConreoller.text = widget.todo!.description;
    }

    _command.addListener(_onSaveTodo);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionConreoller.dispose();
    _command.removeListener(_onSaveTodo);

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
          spacing: 12,
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
          onPressed: _actionTodo,
          label: const Text('Salvar'),
          icon: ListenableBuilder(
            listenable: _command,
            builder: (context, _) {
              if (!_command.running) {
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

  Future<void> _actionTodo() async {
    if (_command.running) return;

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

      _command.execute(newTodo);
    }
  }

  Future<void> _onSaveTodo() async {
    if (_command.running) return;

    if (_command.completed) {
      if (mounted) Navigator.pop(context);
    }
    if (_command.error) {
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

  void _cancelTodo() => Navigator.pop(context);
}
