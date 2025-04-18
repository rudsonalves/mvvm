import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm/data/services/api/api_client.dart';
import 'package:mvvm/domain/models/todo.dart';
import 'package:mvvm/utils/result/result.dart';

void main() {
  late ApiClient apiClient;

  setUp(() {
    apiClient = ApiClient();
  });

  group('Should test [ApiClient]', () {
    test('Should return Result Ok when getTodos()', () async {
      final result = await apiClient.getTodos();

      expect(result.asOk.value, isNotEmpty);
    });

    test('Should return a Todo when creating postTodo()', () async {
      final Todo todo = Todo(id: '1234', name: 'Mais um Todo', description: '');

      final result = await apiClient.postTodo(todo);
      expect(result.asOk.value, isA<Todo>());
    });

    test('Should delete a Todo whe deleteTodo()', () async {
      final result = await apiClient.getTodos();
      expect(result.asOk.value, isNotEmpty);
      final todos = result.asOk.value;

      final todo = Todo(id: '1234', name: 'Mais um novo Todo', description: '');
      final resultPost = await apiClient.postTodo(todo);
      final newTodo = resultPost.asOk.value;
      expect(newTodo.id, isNotNull);

      final resultDelete = await apiClient.deleteTodo(newTodo);
      expect(resultDelete, isNotNull);

      final resultAgain = await apiClient.getTodos();
      expect(todos.length, equals(resultAgain.asOk.value.length));
    });

    test('Should return a Todo when update updateTodo()', () async {
      final Todo todo = Todo(
        id: '1234',
        name: 'Este Todo deve ser atualizado',
        description: '',
      );

      final result = await apiClient.postTodo(todo);
      expect(result.asOk.value, isA<Todo>());

      final resultFinal = result.asOk.value;
      final updateFinal = resultFinal.copyWith(name: 'Nome atualizado!');

      final updateResult = await apiClient.updateTodo(updateFinal);
      expect(updateResult.asOk.value, isA<Todo>());
      expect(updateResult.asOk.value.id, equals(updateFinal.id));
      expect(updateResult.asOk.value.name, equals(updateFinal.name));
    });

    test('Should return a Todo of a know id', () async {
      final todo = Todo(id: '1234', name: 'Conheça a id', description: '');

      final result = await apiClient.postTodo(todo);
      expect(result.asOk.value, isA<Todo>());

      final newTodo = result.asOk.value;
      final getResult = await apiClient.getTodoById(newTodo.id);
      expect(getResult.isOk, true);

      final getTodo = getResult.asOk.value;
      expect(getTodo.id, isNotNull);
      expect(getTodo.id, equals(newTodo.id));
      expect(getTodo.name, equals(newTodo.name));
    });
  });
}
