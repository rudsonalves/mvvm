import 'package:flutter/material.dart';
import 'package:mvvm/domain/models/create_todo.dart';

import '/utils/result/result.dart';
import '/domain/models/todo.dart';

abstract interface class TodosRepository extends ChangeNotifier {
  Map<String, Todo> get todosMap;

  List<Todo> get todos;

  Future<Result<List<Todo>>> getAll();

  Future<Result<Todo>> add(CreateTodo newTodo);

  Future<Result<void>> delete(Todo todo);

  Future<Result<Todo>> update(Todo todo);

  Future<Result<Todo>> get(String id);
}
