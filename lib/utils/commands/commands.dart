import 'package:flutter/material.dart';
import 'package:mvvm/utils/result/result.dart';

// Não possui parâmetro de entrada
typedef CommandAction0<Output> = Future<Result<Output>> Function();

// Possui parâmetro de entrada
typedef CommandAction1<Output, Input> = Future<Result<Output>> Function(Input);

abstract interface class Command<Output> extends ChangeNotifier {
  // Verifica se o comando está em execução
  bool _running = false;

  bool get running => _running;

  // Representa o estado => Ok, Error ou null
  Result<Output>? _result;

  Result<Output>? get result => _result;

  // Verifica de o estado foi gerado com sucesso
  bool get completed => _result is Ok;

  // Verifica se o estado é de erro
  bool get error => _result is Error;

  Future<void> _execute(CommandAction0<Output> action) async {
    // Impede que a action seja executada mais de uma vez.
    if (_running) return;

    _running = true;
    _result = null;

    notifyListeners();

    try {
      _result = await action();
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}

class Command0<Output> extends Command<Output> {
  final CommandAction0<Output> action;

  Command0(this.action);

  Future<void> execute() async {
    await _execute(() => action());
  }
}

class Command1<Output, Input> extends Command<Output> {
  final CommandAction1<Output, Input> action;

  Command1(this.action);

  Future<void> execute(Input parms) async {
    await _execute(() => action(parms));
  }
}
