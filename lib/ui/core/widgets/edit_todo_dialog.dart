import 'package:flutter/material.dart';
import 'package:mvvm/domain/models/create_todo.dart';
import 'package:mvvm/utils/commands/commands.dart';

import '/domain/models/todo.dart';

class EditTodoDialog extends StatefulWidget {
  final Todo? todo;
  final Command1<Todo, Todo>? update;
  final Command1<Todo, CreateTodo>? add;

  const EditTodoDialog({super.key, this.todo, this.update, this.add});

  @override
  State<EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  final _nameController = TextEditingController();
  final _descriptionConreoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final Command1<Todo, Todo>? _update;
  late final Command1<Todo, CreateTodo>? _add;

  @override
  void initState() {
    _update = widget.update;
    _add = widget.add;

    if (widget.todo != null) {
      _nameController.text = widget.todo!.name;
      _descriptionConreoller.text = widget.todo!.description;
    }

    _update?.addListener(_onUpdateTodo);
    _add?.addListener(_onSaveTodo);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionConreoller.dispose();
    _update?.removeListener(_onUpdateTodo);
    _add?.removeListener(_onSaveTodo);

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
          onPressed: _update != null ? _updateTodo : _addTodo,
          label: const Text('Salvar'),
          icon: ListenableBuilder(
            listenable: _update ?? _add!,
            builder: (context, _) {
              final iconData = _add != null ? Icons.add : Icons.update;

              if ((_update?.running ?? false) || (_add?.running ?? false)) {
                return const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                );
              }
              return Icon(iconData);
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

  Future<void> _updateTodo() async {
    if (_update!.running) return;

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final todo = widget.todo!.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionConreoller.text.trim(),
      );

      _update.execute(todo);
    }
  }

  Future<void> _addTodo() async {
    if (_add!.running) return;

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final createTodo = CreateTodo(
        name: _nameController.text.trim(),
        description: _descriptionConreoller.text.trim(),
      );

      _add.execute(createTodo);
    }
  }

  Future<void> _onSaveTodo() async {
    if (_add!.running) return;

    if (_add.completed) {
      if (mounted) Navigator.pop(context);
    }
    if (_add.error) {
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

  Future<void> _onUpdateTodo() async {
    if (_update!.running) return;

    if (_update.completed) {
      if (mounted) Navigator.pop(context);
    }
    if (_update.error) {
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
