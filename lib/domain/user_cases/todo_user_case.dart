import 'dart:developer';

import 'package:logging/logging.dart';
import 'package:mvvm/data/repositories/todos/todos_repository.dart';
import 'package:mvvm/domain/models/create_todo.dart';
import 'package:mvvm/domain/models/todo.dart';
import 'package:mvvm/utils/result/result.dart';

class TodoUserCase {
  final TodosRepository _todosRepository;

  TodoUserCase({required TodosRepository todosRepository})
    : _todosRepository = todosRepository;

  final _log = Logger('TodoUserCase');

  Future<Result<Todo>> upgradeTodo(Todo todo) async {
    final result = await _todosRepository.update(todo);

    result.fold(
      onOk: (todo) {
        _log.fine('Todo updated');
      },
      onError: (err) {
        _log.warning(err.toString());
      },
    );

    return result;
  }

  Future<Result<Todo>> addTodo(CreateTodo newTodo) async {
    final result = await _todosRepository.add(newTodo);

    result.fold(
      onOk: (todo) {
        _log.fine('Todo added');
      },
      onError: (err) {
        _log.warning(err.toString());
      },
    );

    return result;
  }
}
