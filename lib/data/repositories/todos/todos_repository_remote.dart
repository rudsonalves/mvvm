import 'package:mvvm/data/repositories/todos/todos_repository.dart';
import 'package:mvvm/data/services/api/api_client.dart';
import 'package:mvvm/domain/models/todo.dart';
import 'package:mvvm/utils/result/result.dart';

class TodosRepositoryRemote implements TodosRepository {
  final ApiClient _apiClient;

  TodosRepositoryRemote({required ApiClient apiClient})
    : _apiClient = apiClient;

  final Map<String, Todo> _todosMap = {};

  List<Todo> get todos => _todosMap.values.toList();

  @override
  Future<Result<Todo>> add(String name) async {
    final result = await _apiClient.postTodo(Todo(name: name));

    if (result.isSuccess) {
      final newTodo = result.asOk.value;
      if (newTodo.id == null) {
        return Result.error(Exception('Todo id return null'));
      }
      _todosMap[newTodo.id!] = newTodo;
    }
    return result;
  }

  @override
  Future<Result<void>> delete(Todo todo) async {
    final result = await _apiClient.deleteTodo(todo);

    if (result.isSuccess) {
      _todosMap.remove(todo.id);
    }
    return result;
  }

  @override
  Future<Result<List<Todo>>> getAll() async {
    try {
      final result = await _apiClient.getTodos();

      if (result.isSuccess) {
        final todos = result.asOk.value;
        _todosMap.clear();
        _todosMap.addEntries(todos.map((todo) => MapEntry(todo.id!, todo)));
      }
      return result;
    } catch (err) {
      _todosMap.clear();
      return Result.error(Exception('Unknow error: $err'));
    }
  }
}
