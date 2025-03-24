import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm/data/repositories/todos/todos_repository.dart';
import 'package:mvvm/data/repositories/todos/todos_repository_dev.dart';
import 'package:mvvm/domain/models/todo.dart';
import 'package:mvvm/ui/todo/view_models/todo_view_model.dart';

void main() {
  late TodoViewModel todoViewModel;
  late TodosRepository todosRepository;
  setUp(() {
    todosRepository = TodosRepositoryDev();
    todoViewModel = TodoViewModel(todosRepository: todosRepository);
  });

  group('Should test TodoViewModel', () {
    test('Verify ViewModel initialState', () {
      expect(todoViewModel.todos, isEmpty);
      expect(todoViewModel.load, isNotNull);
      expect(todoViewModel.addTodo, isNotNull);

      // expect(todoViewmodel.load.running, false);
    });

    // test('Should add Todo', () async {
    //   await todoViewModel.addTodo.execute('Novo Todo');

    //   expect(todoViewModel.todos, isNotEmpty);
    //   expect(todoViewModel.todos.first.name, contains('Novo Todo'));
    //   expect(todoViewModel.todos.first.id, 0);
    // });

    test('Should remove Todo', () async {
      await todoViewModel.addTodo.execute(
        Todo(name: 'Novo Todo', description: ''),
      );
      await todoViewModel.addTodo.execute(
        Todo(name: 'Novo Todo2', description: ''),
      );

      final todo = todoViewModel.todos[0];
      expect(todoViewModel.todos.length, 2);

      await todoViewModel.deleteTodo.execute(todo);

      expect(todoViewModel.todos.length, 1);
      expect(todoViewModel.todos.first.name, isNot(todo.name));
    });
  });
}
