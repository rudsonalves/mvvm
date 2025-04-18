import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm/data/repositories/todos/todos_repository.dart';
import 'package:mvvm/data/repositories/todos/todos_repository_dev.dart';
import 'package:mvvm/domain/models/todo.dart';
import 'package:mvvm/domain/user_cases/todo_update_user_case.dart';
import 'package:mvvm/ui/features/todo/todo_view_model.dart';

void main() {
  late TodoViewModel todoViewModel;
  late TodosRepository todosRepository;
  late TodoUpdateUserCase todoUpdateUserCase;

  setUp(() {
    todosRepository = TodosRepositoryDev();
    todoUpdateUserCase = TodoUpdateUserCase(todosRepository: todosRepository);

    todoViewModel = TodoViewModel(
      todoUpdateUserCase: todoUpdateUserCase,
      todosRepository: todosRepository,
    );
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
