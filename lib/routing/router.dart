import 'package:go_router/go_router.dart';

import '/domain/user_cases/todo_update_user_case.dart';
import '/data/repositories/todos/todos_repository.dart';
import '/data/repositories/todos/todos_repository_remote.dart';
import '/data/services/api/api_client.dart';
import '/routing/routes.dart';
import '../ui/features/todo/todo_view_model.dart';
import '../ui/features/todo/todo_screen.dart';
import '../ui/features/todo_details/todo_details_screen.dart';
import '../ui/features/todo_details/todo_details_view_model.dart';

GoRouter reouterConfig() {
  final TodosRepository todoRepository = TodosRepositoryRemote(
    apiClient: ApiClient(host: '192.168.0.22'),
  );

  final todoUpdateUserCase = TodoUpdateUserCase(
    todosRepository: todoRepository,
  );

  return GoRouter(
    initialLocation: Routes.todos,
    routes: [
      GoRoute(
        path: Routes.todos,
        builder:
            (context, state) => TodoScreen(
              todoViewModel: TodoViewModel(
                todoUpdateUserCase: todoUpdateUserCase,
                todosRepository: todoRepository,
              ),
            ),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id'] as String;
              final todoDetailsViewModel = TodoDetailsViewModel(
                todoUpdateUserCase: todoUpdateUserCase,
                todoRepository: todoRepository,
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
