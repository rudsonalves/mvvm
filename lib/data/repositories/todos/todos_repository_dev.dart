import 'package:flutter/material.dart';
import 'package:mvvm/domain/models/create_todo.dart';
import 'package:uuid/uuid.dart';

import '/utils/result/result.dart';
import '/data/repositories/todos/todos_repository.dart';
import '/domain/models/todo.dart';

class TodosRepositoryDev extends ChangeNotifier implements TodosRepository {
  final List<Todo> _todos = [];

  @override
  Future<Result<List<Todo>>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.ok(_todos);
  }

  @override
  Map<String, Todo> get todosMap => {};

  @override
  List<Todo> get todos => _todos;

  final _uuid = const Uuid();

  @override
  Future<Result<Todo>> get(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      final findTodo = _todos.firstWhere((todo) => todo.id == id);
      return Result.ok(findTodo);
    } catch (err) {
      return Result.error(Exception('Todo not found'));
    }
  }

  @override
  Future<Result<Todo>> add(CreateTodo newTodo) async {
    final id = _uuid.v4();
    final todo = Todo(
      id: id,
      name: newTodo.name,
      description: newTodo.description,
    );

    await Future.delayed(const Duration(milliseconds: 200));

    _todos.add(todo);

    return Result.ok(todo);
  }

  @override
  Future<Result<void>> delete(Todo todo) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_todos.contains(todo)) {
      _todos.remove(todo);
      return const Result.ok(null);
    }
    return Result.error(Exception('Todo not found'));
  }

  @override
  Future<Result<Todo>> update(Todo todo) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      return Result.ok(todo);
    } else {
      return Result.error(Exception('Todo id ${todo.id} not found'));
    }
  }
}
