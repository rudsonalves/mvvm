import 'package:flutter/material.dart';
import 'package:mvvm/data/repositories/todos/todos_repository.dart';
import 'package:mvvm/domain/models/todo.dart';
import 'package:mvvm/utils/commands/commands.dart';
import 'package:mvvm/utils/result/result.dart';

class TodoDetailsViewModel extends ChangeNotifier {
  late Command1<Todo, String> load;
  late Command1<Todo, Todo> upgrade;
  final TodosRepository _todoRepository;

  TodoDetailsViewModel({required TodosRepository todoRepository})
    : _todoRepository = todoRepository {
    load = Command1<Todo, String>(_loadTodo);
    upgrade = Command1<Todo, Todo>(_upgradeTodo);
  }

  late Todo _todo;
  Todo get todo => _todo;

  Future<Result<Todo>> _loadTodo(String id) async {
    final result = await _todoRepository.get(id);

    result.fold(
      onOk: (todo) {
        _todo = todo;
      },
      onError: (error) {},
    );

    notifyListeners();
    return result;
  }

  Future<Result<Todo>> _upgradeTodo(Todo todo) async {
    final result = await _todoRepository.update(todo);

    result.fold(
      onOk: (todo) {
        _todo = todo;
      },
      onError: (erro) {},
    );

    notifyListeners();
    return result;
  }
}
