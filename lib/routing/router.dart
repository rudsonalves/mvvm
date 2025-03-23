import 'package:go_router/go_router.dart';

import 'package:mvvm/data/repositories/todos/todos_repository_remote.dart';
import 'package:mvvm/data/services/api/api_client.dart';
import 'package:mvvm/routing/routes.dart';
import 'package:mvvm/ui/todo/view_models/todo_view_model.dart';
import 'package:mvvm/ui/todo/todo_screen.dart';
import 'package:mvvm/ui/todo_details/todo_details_screen.dart';
import 'package:mvvm/ui/todo_details/view_models/todo_details_view_model.dart';

GoRouter reouterConfig() {
  return GoRouter(
    initialLocation: Routes.todos,
    routes: [
      GoRoute(
        path: Routes.todos,
        builder:
            (context, state) => TodoScreen(
              todoViewModel: TodoViewModel(
                todosRepository: TodosRepositoryRemote(
                  apiClient: ApiClient(host: '192.168.0.22'),
                ),
              ),
            ),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return TodoDetailsScreen(
                id: id!,
                todoDetailsViewModel: TodoDetailsViewModel(
                  todoRepository: TodosRepositoryRemote(apiClient: ApiClient()),
                  id: id,
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
}
