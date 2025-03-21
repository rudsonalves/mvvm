import 'package:mvvm/utils/result/result.dart';
import 'package:mvvm/data/repositories/todos/todos_repository.dart';
import 'package:mvvm/domain/models/todo.dart';

class TodosReposotoryDev implements TodosRepository {
  final List<Todo> _todos = [];
  @override
  Future<Result<List<Todo>>> get() async {
    await Future.delayed(Duration(milliseconds: 200));
    return Result.ok(_todos);
  }

  @override
  Future<Result<Todo>> add(String name) async {
    final lastTodoIndex = _todos.length.toString();
    await Future.delayed(Duration(milliseconds: 200));

    final todo = Todo(id: lastTodoIndex, name: name);
    _todos.add(todo);

    return Result.ok(todo);
  }

  @override
  Future<Result<void>> delete(Todo todo) async {
    await Future.delayed(Duration(milliseconds: 200));
    if (_todos.contains(todo)) {
      _todos.remove(todo);
      return Result.ok(null);
    }

    return Result.error(Exception('Todo not found'));
  }
}
