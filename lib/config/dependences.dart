import 'package:mvvm/data/repositories/todos/todos_repository_remote.dart';
import 'package:mvvm/data/services/api/api_client.dart';
import 'package:mvvm/domain/user_cases/todo_user_case.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get remoteProviders => [
  Provider<ApiClient>(create: (_) => ApiClient(host: '192.168.0.22')),
  ChangeNotifierProvider<TodosRepositoryRemote>(
    create:
        (context) =>
            TodosRepositoryRemote(apiClient: context.read<ApiClient>()),
  ),
  ..._sharedProviders,
];

List<SingleChildWidget> get _sharedProviders => [
  Provider(
    create:
        (context) => TodoUserCase(
          todosRepository: context.read<TodosRepositoryRemote>(),
        ),
  ),
];
