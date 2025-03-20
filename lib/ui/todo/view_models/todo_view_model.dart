import 'package:flutter/material.dart';
import 'package:mvvm/core/commands/commands.dart';
import 'package:mvvm/core/result/result.dart';
import 'package:mvvm/domain/models/todo.dart';

class TodoViewModel extends ChangeNotifier {
  late Command0 load;
  late Command1<Todo, String> addTodo;
  late Command1<void, Todo> deleteTodo;

  TodoViewModel() {
    load = Command0(_load)..execute();
    addTodo = Command1<Todo, String>(_addTodo);
    deleteTodo = Command1<void, Todo>(_deleteTodo);
  }

  final List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<Result> _load() async {
    await Future.delayed(Duration(milliseconds: 200));

    final todos = <Todo>[];

    _todos.clear();
    _todos.addAll(todos);

    notifyListeners();

    return Result.ok(todos);
  }

  Future<Result<Todo>> _addTodo(String name) async {
    await Future.delayed(Duration(milliseconds: 200));
    final lastTodoIndex = _todos.length;

    final createdTodo = Todo(id: lastTodoIndex, name: name);

    _todos.add(createdTodo);
    notifyListeners();
    return Result.ok(createdTodo);
  }

  Future<Result<void>> _deleteTodo(Todo todo) async {
    await Future.delayed(Duration(milliseconds: 200));

    _todos.remove(todo);
    notifyListeners();
    return Result.ok(null);
  }
}
