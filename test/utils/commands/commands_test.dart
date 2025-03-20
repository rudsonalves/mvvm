import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm/utils/commands/commands.dart';
import 'package:mvvm/utils/result/result.dart';

void main() {
  group('Should test Commands', () {
    test('Should test Command0 returns Ok', () async {
      final command0 = Command0<String>(getOkResult);

      expect(command0.completed, false);
      expect(command0.running, false);
      expect(command0.error, false);
      expect(command0.result, isNull);

      await command0.execute();

      expect(command0.completed, true);
      expect(command0.running, false);
      expect(command0.error, false);
      expect(command0.result, isA<Result<String>>());
      expect(command0.result!.asOk.value, 'Operation has Sucesses');
    });

    test('Should test Command0 returns Error', () async {
      final command0 = Command0<bool>(getErrorResult);

      expect(command0.completed, false);
      expect(command0.running, false);
      expect(command0.error, false);
      expect(command0.result, isNull);

      await command0.execute();

      expect(command0.running, false);
      expect(command0.error, true);
      expect(command0.result, isA<Error<bool>>());
      expect(command0.result!.asError.error, isA<Exception>());
    });

    test('Should test Command1 returns Ok', () async {
      final command1 = Command1<String, int>(getOkResultInt);

      expect(command1.completed, false);
      expect(command1.running, false);
      expect(command1.error, false);
      expect(command1.result, isNull);

      final time = 1000;
      await command1.execute(time);

      expect(command1.completed, true);
      expect(command1.running, false);
      expect(command1.error, false);
      expect(command1.result, isA<Result<String>>());
      expect(command1.result!.asOk.value, 'Operation has Sucesses $time');
    });

    test('Should test Command1 returns Error', () async {
      final command1 = Command1<String, bool>(getErrorResultBool);

      expect(command1.completed, false);
      expect(command1.running, false);
      expect(command1.error, false);
      expect(command1.result, isNull);

      final isTrue = true;
      await command1.execute(isTrue);

      expect(command1.running, false);
      expect(command1.error, true);
      expect(command1.result, isA<Error<String>>());
      expect(command1.result!.asError.error, isA<Exception>());
    });
  });
}

Future<Result<String>> getOkResult() async {
  await Future.delayed(Duration(milliseconds: 500));
  return Result.ok('Operation has Sucesses');
}

Future<Result<bool>> getErrorResult() async {
  await Future.delayed(Duration(milliseconds: 500));
  return Result.error(Exception('An error occurred while genrating state'));
}

Future<Result<String>> getOkResultInt(int time) async {
  await Future.delayed(Duration(milliseconds: time));
  return Result.ok('Operation has Sucesses $time');
}

Future<Result<String>> getErrorResultBool(bool isTrue) async {
  await Future.delayed(Duration(milliseconds: isTrue ? 1000 : 500));
  return Result.error(Exception('An error occurred $isTrue'));
}
