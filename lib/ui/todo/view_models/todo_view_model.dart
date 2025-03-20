import 'package:flutter/material.dart';
import 'package:mvvm/utils/commands/commands.dart';
import 'package:mvvm/utils/result/result.dart';
import 'package:mvvm/data/repositories/todos/todos_repository.dart';
import 'package:mvvm/domain/models/todo.dart';

class TodoViewModel extends ChangeNotifier {
  late Command0 load;
  late Command1<Todo, String> addTodo;
  late Command1<void, Todo> deleteTodo;
  final TodosRepository _todosRepository;

  TodoViewModel({required todosRepository})
    : _todosRepository = todosRepository {
    load = Command0(_load)..execute();
    addTodo = Command1<Todo, String>(_addTodo);
    deleteTodo = Command1<void, Todo>(_deleteTodo);
  }

  final List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<Result> _load() async {
    final result = await _todosRepository.get();

    switch (result) {
      case Ok<List<Todo>>():
        _todos.clear();
        _todos.addAll(result.value);
        notifyListeners();
        break;
      case Error():
        // TODO: implement logging
        break;
    }

    return result;
  }

  Future<Result<Todo>> _addTodo(String name) async {
    final result = await _todosRepository.add(name);

    switch (result) {
      case Ok<Todo>():
        _todos.add(result.value);
        notifyListeners();
        break;
      case Error():
        // TODO: implement logging
        break;
    }

    return result;
  }

  Future<Result<void>> _deleteTodo(Todo todo) async {
    final result = await _todosRepository.delete(todo);

    switch (result) {
      case Ok<void>():
        _todos.remove(todo);
        notifyListeners();
        break;
      case Error():
        // TODO: implement logging
        break;
    }

    return result;
  }
}
