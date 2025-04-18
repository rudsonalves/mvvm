import 'dart:developer';

import 'package:mvvm/data/repositories/todos/todos_repository.dart';
import 'package:mvvm/domain/models/create_todo.dart';
import 'package:mvvm/domain/models/todo.dart';
import 'package:mvvm/utils/result/result.dart';

class TodoUserCase {
  final TodosRepository _todosRepository;

  TodoUserCase({required TodosRepository todosRepository})
    : _todosRepository = todosRepository;

  Future<Result<Todo>> upgradeTodo(Todo todo) async {
    final result = await _todosRepository.update(todo);

    result.fold(
      onOk: (todo) {
        log('Todo updated');
      },
      onError: (err) {
        log(err.toString());
      },
    );

    return result;
  }

  Future<Result<Todo>> addTodo(CreateTodo newTodo) async {
    final result = await _todosRepository.add(newTodo);

    result.fold(
      onOk: (todo) {
        log('Todo updated');
      },
      onError: (err) {
        log(err.toString());
      },
    );

    return result;
  }
}
