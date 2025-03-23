import 'package:mvvm/utils/result/result.dart';
import 'package:mvvm/domain/models/todo.dart';

abstract interface class TodosRepository {
  Future<Result<List<Todo>>> getAll();

  Future<Result<Todo>> add(String name);

  Future<Result<void>> delete(Todo todo);

  Future<Result<Todo>> update(Todo todo);

  Future<Result<Todo>> get(String id);
}
