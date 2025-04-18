import 'package:flutter/material.dart';
import 'package:mvvm/domain/user_cases/todo_update_user_case.dart';

import '/data/repositories/todos/todos_repository.dart';
import '/domain/models/todo.dart';
import '/utils/commands/commands.dart';
import '/utils/result/result.dart';

class TodoDetailsViewModel extends ChangeNotifier {
  final TodosRepository _todoRepository;
  final TodoUserCase _todoUpdateUserCase;

  TodoDetailsViewModel({
    required TodosRepository todoRepository,
    required TodoUserCase todoUpdateUserCase,
  }) : _todoRepository = todoRepository,
       _todoUpdateUserCase = todoUpdateUserCase {
    load = Command1<Todo, String>(_loadTodo);
    upgrade = Command1<Todo, Todo>(_todoUpdateUserCase.upgradeTodo);
    _todoRepository.addListener(() {
      load.execute(_todo.id);
    });
  }

  late Command1<Todo, String> load;
  late Command1<Todo, Todo> upgrade;

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
}
