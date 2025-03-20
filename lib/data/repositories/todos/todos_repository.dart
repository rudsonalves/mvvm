import 'package:mvvm/core/result/result.dart';
import 'package:mvvm/domain/models/todo.dart';

abstract interface class TodosRepository {
  Future<Result<List<Todo>>> get();

  Future<Result<Todo>> add(String name);

  Future<Result<void>> delete(Todo todo);
}
