import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:mvvm/domain/models/todo.dart';
import 'package:mvvm/utils/result/result.dart';

class ApiClient {
  final String _host;
  final int _port;
  final HttpClient Function() _clientHttpFactory;

  ApiClient({String? host, int? port, HttpClient Function()? clientHttpFactory})
    : _host = host ?? 'localhost',
      _port = port ?? 3000,
      _clientHttpFactory = clientHttpFactory ?? HttpClient.new;

  static const todosPath = '/todos';

  Future<Result<List<Todo>>> getTodos() async {
    final client = _clientHttpFactory();
    try {
      final request = await client.get(_host, _port, todosPath);

      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final stringData = await response.transform(utf8.decoder).join();
        final map = jsonDecode(stringData) as List<dynamic>;
        final mapList = map.whereType<Map<String, dynamic>>().toList();
        final todos = mapList.map(Todo.fromMap).toList();

        return Result.ok(todos);
      } else {
        throw Exception(
          HttpException('Invalid response: ${response.statusCode}'),
        );
      }
    } on Exception catch (err) {
      log(err.toString());
      return Result.error(err);
    } catch (err) {
      log(err.toString());
      return Result.error(Exception(err));
    } finally {
      client.close();
    }
  }

  Future<Result<Todo>> getTodoById(String id) async {
    final client = _clientHttpFactory();
    try {
      final request = await client.get(_host, _port, '$todosPath/$id');
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final json = await response.transform(utf8.decoder).join();
        final todo = Todo.fromJson(json);

        return Result.ok(todo);
      } else {
        throw Exception(
          HttpException('Invalid response: ${response.statusCode}'),
        );
      }
    } on Exception catch (err) {
      log(err.toString());
      return Result.error(err);
    } catch (err) {
      log(err.toString());
      return Result.error(Exception(err));
    } finally {
      client.close();
    }
  }

  Future<Result<Todo>> postTodo(Todo todo) async {
    final client = _clientHttpFactory();

    try {
      final request = await client.post(_host, _port, todosPath);

      request.write(todo.toJson());

      final response = await request.close();

      if (response.statusCode == HttpStatus.created) {
        final stringData = await response.transform(utf8.decoder).join();
        final createdTodo = Todo.fromMap(
          jsonDecode(stringData) as Map<String, dynamic>,
        );
        return Result.ok(createdTodo);
      } else {
        throw Exception(
          HttpException('Invalid response: ${response.statusCode}'),
        );
      }
    } on Exception catch (err) {
      log(err.toString());
      return Result.error(err);
    } catch (err) {
      log(err.toString());
      return Result.error(Exception(err));
    } finally {
      client.close();
    }
  }

  Future<Result<void>> deleteTodo(Todo todo) async {
    final client = _clientHttpFactory();

    try {
      final request = await client.delete(
        _host,
        _port,
        '$todosPath/${todo.id}',
      );
      final response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        return Result.ok(null);
      } else {
        throw Exception(
          HttpException('Invalid response: ${response.statusCode}'),
        );
      }
    } on Exception catch (err) {
      log(err.toString());
      return Result.error(err);
    } catch (err) {
      log(err.toString());
      return Result.error(Exception(err));
    } finally {
      client.close();
    }
  }

  Future<Result<Todo>> updateTodo(Todo todo) async {
    final client = _clientHttpFactory();

    try {
      final request = await client.put(_host, _port, '$todosPath/${todo.id}');

      request.write(todo.toJson());

      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final stringData = await response.transform(utf8.decoder).join();
        final createdTodo = Todo.fromMap(
          jsonDecode(stringData) as Map<String, dynamic>,
        );
        return Result.ok(createdTodo);
      } else {
        throw Exception(
          HttpException('Invalid response: ${response.statusCode}'),
        );
      }
    } on Exception catch (err) {
      log(err.toString());
      return Result.error(err);
    } catch (err) {
      log(err.toString());
      return Result.error(Exception(err));
    } finally {
      client.close();
    }
  }
}
