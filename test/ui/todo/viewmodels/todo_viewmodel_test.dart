import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm/ui/todo/view_models/todo_view_model.dart';

void main() {
  group('Should test TodoViewModel', () {
    test('Verify ViewModel initialState', () {
      final TodoViewModel todoViewmodel = TodoViewModel();

      expect(todoViewmodel.todos, isEmpty);
      expect(todoViewmodel.load, isNotNull);
      expect(todoViewmodel.addTodo, isNotNull);

      // expect(todoViewmodel.load.running, false);
    });

    test('Should add Todo', () async {
      final todoViewModel = TodoViewModel();

      await todoViewModel.addTodo.execute('Novo Todo');

      expect(todoViewModel.todos, isNotEmpty);
      expect(todoViewModel.todos.first.name, contains('Novo Todo'));
      expect(todoViewModel.todos.first.id, 0);
    });

    test('Should remove Todo', () async {
      final todoViewModel = TodoViewModel();

      await todoViewModel.addTodo.execute('Novo Todo');
      await todoViewModel.addTodo.execute('Novo Todo2');

      final todo = todoViewModel.todos[0];
      expect(todoViewModel.todos.length, 2);

      await todoViewModel.deleteTodo.execute(todo);

      expect(todoViewModel.todos.length, 1);
      expect(todoViewModel.todos.first.name, isNot(todo.name));
    });
  });
}
