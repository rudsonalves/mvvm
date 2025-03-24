import 'package:mvvm/utils/result/result.dart';
import 'package:mvvm/domain/models/todo.dart';

abstract interface class TodosRepository {
  Map<String, Todo> get todosMap;

  List<Todo> get todos;

  Future<Result<List<Todo>>> getAll();

  Future<Result<Todo>> add(Todo todo);

  Future<Result<void>> delete(Todo todo);

  Future<Result<Todo>> update(Todo todo);

  Future<Result<Todo>> get(String id);
}
