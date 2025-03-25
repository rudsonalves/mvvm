import 'dart:developer';

import '/data/repositories/todos/todos_repository.dart';
import '/data/services/api/api_client.dart';
import '/domain/models/todo.dart';
import '/utils/result/result.dart';

class TodosRepositoryRemote implements TodosRepository {
  final ApiClient _apiClient;

  TodosRepositoryRemote({required ApiClient apiClient})
    : _apiClient = apiClient;

  final Map<String, Todo> _todosMap = {};

  @override
  Map<String, Todo> get todosMap => _todosMap;

  @override
  List<Todo> get todos => _todosMap.values.toList();

  @override
  Future<Result<Todo>> add(Todo todo) async {
    final result = await _apiClient.postTodo(todo);

    result.fold(
      onOk: (todo) {
        final newTodo = result.asOk.value;
        if (newTodo.id == null) {
          return Result.error(Exception('Todo id return null'));
        }
        _todosMap[newTodo.id!] = newTodo;
      },
      onError: (err) {
        log('Have a error: $err');
      },
    );

    return result;
  }

  @override
  Future<Result<void>> delete(Todo todo) async {
    final result = await _apiClient.deleteTodo(todo);

    result.fold(
      onOk: (_) {
        _todosMap.remove(todo.id);
      },
      onError: (err) {
        log('Have a error: $err');
      },
    );

    return result;
  }

  @override
  Future<Result<List<Todo>>> getAll() async {
    try {
      final result = await _apiClient.getTodos();

      result.fold(
        onOk: (todos) {
          _todosMap.clear();
          _todosMap.addEntries(todos.map((todo) => MapEntry(todo.id!, todo)));
        },
        onError: (err) {
          log('Have a error: $err');
        },
      );

      return result;
    } catch (err) {
      _todosMap.clear();
      return Result.error(Exception('Unknow error: $err'));
    }
  }

  @override
  Future<Result<Todo>> get(String id) async {
    try {
      final result = await _apiClient.getTodoById(id);

      result.fold(
        onOk: (todo) {
          _todosMap[todo.id!] = todo;
        },
        onError: (err) {
          log('Have a error: $err');
        },
      );

      return result;
    } catch (err) {
      _todosMap.clear();
      return Result.error(Exception('Unknow error: $err'));
    }
  }

  @override
  Future<Result<Todo>> update(Todo todo) async {
    try {
      final result = await _apiClient.updateTodo(todo);

      result.fold(
        onOk: (todo) {
          _todosMap[todo.id!] = todo;
        },
        onError: (err) {
          log('Have a error: $err');
        },
      );

      return result;
    } catch (err) {
      _todosMap.clear();
      return Result.error(Exception('Unknow error: $err'));
    }
  }
}
