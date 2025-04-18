import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../domain/user_cases/todo_user_case.dart';
import '/data/repositories/todos/todos_repository_remote.dart';
import '/routing/routes.dart';
import '../ui/features/todo/todo_view_model.dart';
import '../ui/features/todo/todo_screen.dart';
import '../ui/features/todo_details/todo_details_screen.dart';
import '../ui/features/todo_details/todo_details_view_model.dart';

GoRouter reouterConfig() {
  return GoRouter(
    initialLocation: Routes.todos,
    routes: [
      GoRoute(
        path: Routes.todos,
        builder:
            (context, state) => TodoScreen(
              todoViewModel: TodoViewModel(
                todoUserCase: context.read<TodoUserCase>(),
                todosRepository: context.read<TodosRepositoryRemote>(),
              ),
            ),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id'] as String;
              final todoDetailsViewModel = TodoDetailsViewModel(
                todoUserCase: context.read<TodoUserCase>(),
                todoRepository: context.read<TodosRepositoryRemote>(),
              );

              todoDetailsViewModel.load.execute(id);

              return TodoDetailsScreen(
                todoDetailsViewModel: todoDetailsViewModel,
              );
            },
          ),
        ],
      ),
    ],
  );
}
