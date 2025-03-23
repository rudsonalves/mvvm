import 'package:flutter/material.dart';
import 'package:mvvm/data/repositories/todos/todos_repository.dart';
import 'package:mvvm/domain/models/todo.dart';
import 'package:mvvm/utils/commands/commands.dart';
import 'package:mvvm/utils/result/result.dart';

class TodoDetailsViewModel extends ChangeNotifier {
  late Command0 load;
  late Command1<Todo, Todo> upgrade;
  final TodosRepository _todoRepository;
  final String id;

  TodoDetailsViewModel({
    required TodosRepository todoRepository,
    required this.id,
  }) : _todoRepository = todoRepository {
    load = Command0(_loadTodo)..execute();
    upgrade = Command1<Todo, Todo>(_upgradeTodo);
  }

  late Todo todo;

  Future<Result<Todo>> _loadTodo() async {
    final result = await _todoRepository.get(id);

    result.fold(
      onSuccess: (todo) {
        this.todo = todo;
        notifyListeners();
      },
      onFailure: (error) {},
    );

    return result;
  }

  Future<Result<Todo>> _upgradeTodo(Todo todo) async {
    final result = await _todoRepository.update(todo);

    result.fold(
      onSuccess: (todo) {
        this.todo = todo;
        notifyListeners();
      },
      onFailure: (erro) {},
    );

    return result;
  }
}
