sealed class Routes {
  static const todos = '/todos';
  static String todoDetails(String todoId) => '$todos/$todoId';
}
