import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mvvm/domain/models/create_todo.dart';
import 'package:mvvm/domain/user_cases/todo_user_case.dart';

import '/utils/commands/commands.dart';
import '/utils/result/result.dart';
import '/data/repositories/todos/todos_repository.dart';
import '/domain/models/todo.dart';

class TodoViewModel extends ChangeNotifier {
  final TodosRepository _todosRepository;
  final TodoUserCase _todoUpdateUserCase;

  TodoViewModel({
    required TodosRepository todosRepository,
    required TodoUserCase todoUserCase,
  }) : _todosRepository = todosRepository,
       _todoUpdateUserCase = todoUserCase {
    load = Command0(_load)..execute();
    addTodo = Command1<Todo, CreateTodo>(_addTodo);
    deleteTodo = Command1<void, Todo>(_deleteTodo);
    updateTodo = Command1<Todo, Todo>(_todoUpdateUserCase.upgradeTodo);
    _todosRepository.addListener(() {
      load.execute();
    });
  }

  late Command0 load;
  late Command1<Todo, CreateTodo> addTodo;
  late Command1<void, Todo> deleteTodo;
  late Command1<Todo, Todo> updateTodo;

  Map<String, Todo> get todosMap => _todosRepository.todosMap;

  List<Todo> get todos => _todosRepository.todos;

  final _log = Logger('TodoViewModel');

  Future<Result> _load() async {
    final result = await _todosRepository.getAll();
    notifyListeners();
    return result;
  }

  Future<Result<Todo>> _addTodo(CreateTodo todo) async {
    final result = await _todosRepository.add(todo);

    result.fold(
      onOk: (todo) {
        _log.fine('Todo updated');
      },
      onError: (err) {
        _log.warning(err.toString());
      },
    );

    notifyListeners();
    return result;
  }

  Future<Result<void>> _deleteTodo(Todo todo) async {
    final result = await _todosRepository.delete(todo);

    result.fold(
      onOk: (_) {
        _log.fine('Todo deleted');
      },
      onError: (err) {
        _log.warning(err.toString());
      },
    );

    notifyListeners();
    return result;
  }
}
