import 'package:mvvm/utils/result/result.dart';
import 'package:mvvm/data/repositories/todos/todos_repository.dart';
import 'package:mvvm/domain/models/todo.dart';

class TodosRepositoryDev implements TodosRepository {
  final List<Todo> _todos = [];

  @override
  Future<Result<List<Todo>>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.ok(_todos);
  }

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
  Future<Result<Todo>> add(String name) async {
    final lastTodoIndex = _todos.length.toString();
    await Future.delayed(const Duration(milliseconds: 200));

    final todo = Todo(id: lastTodoIndex, name: name);
    _todos.add(todo);

    return Result.ok(todo);
  }

  @override
  Future<Result<void>> delete(Todo todo) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_todos.contains(todo)) {
      _todos.remove(todo);
      return Result.ok(null);
    }
    return Result.error(Exception('Todo not found'));
  }

  @override
  Future<Result<Todo>> update(Todo todo) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _todos.indexWhere((t) => t.id! == todo.id!);
    if (index != -1) {
      _todos[index] = todo;
      return Result.ok(todo);
    } else {
      return Result.error(Exception('Todo id ${todo.id} not found'));
    }
  }
}
