import 'package:flutter/material.dart';

import '/utils/commands/commands.dart';
import '/utils/result/result.dart';
import '/data/repositories/todos/todos_repository.dart';
import '/domain/models/todo.dart';

class TodoViewModel extends ChangeNotifier {
  late Command0 load;
  late Command1<Todo, Todo> addTodo;
  late Command1<void, Todo> deleteTodo;
  late Command1<Todo, Todo> updateTodo;
  final TodosRepository _todosRepository;

  TodoViewModel({required todosRepository})
    : _todosRepository = todosRepository {
    load = Command0(_load)..execute();
    addTodo = Command1<Todo, Todo>(_addTodo);
    deleteTodo = Command1<void, Todo>(_deleteTodo);
    updateTodo = Command1<Todo, Todo>(_updateTodo);
  }

  Map<String, Todo> get todosMap => _todosRepository.todosMap;

  List<Todo> get todos => _todosRepository.todos;

  Future<Result> _load() async {
    final result = await _todosRepository.getAll();
    notifyListeners();
    return result;
  }

  Future<Result<Todo>> _addTodo(Todo todo) async {
    final result = await _todosRepository.add(todo);
    notifyListeners();
    return result;
  }

  Future<Result<Todo>> _updateTodo(Todo todo) async {
    final result = await _todosRepository.update(todo);
    notifyListeners();
    return result;
  }

  Future<Result<void>> _deleteTodo(Todo todo) async {
    final result = await _todosRepository.delete(todo);
    notifyListeners();
    return result;
  }
}
