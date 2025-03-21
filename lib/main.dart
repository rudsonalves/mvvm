import 'package:flutter/material.dart';
import 'package:mvvm/data/repositories/todos/todos_repository_remote.dart';
import 'package:mvvm/data/services/api/api_client.dart';
import 'package:mvvm/ui/todo/view_models/todo_view_model.dart';
import 'package:mvvm/ui/todo/widgets/todo_screen.dart';

void main() {
  runApp(AppMaterial());
}

class AppMaterial extends StatelessWidget {
  const AppMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: TodoScreen(
        todoViewModel: TodoViewModel(
          todosRepository: TodosRepositoryRemote(
            apiClient: ApiClient(host: '192.168.0.22'),
          ),
        ),
      ),
    );
  }
}
