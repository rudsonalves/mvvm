abstract interface class Result<T> {
  const Result();

  factory Result.ok(T value) = Ok._;

  factory Result.error(Exception error) = Error._;

  bool get isSuccess;

  bool get isFailure;

  // Teas Off
  // factory Result.ok(T value) => Ok._(value);

  // factory Result.error(Exception error) => Error._(error);
}

final class Ok<T> extends Result<T> {
  final T value;

  Ok._(this.value);

  @override
  bool get isSuccess => true;

  @override
  bool get isFailure => false;
}

final class Error<T> extends Result<T> {
  final Exception error;

  Error._(this.error);

  @override
  bool get isSuccess => false;

  @override
  bool get isFailure => true;
}

extension ResultExtension on Object {
  Result ok() => Result.ok(this);
}

extension ResultException on Exception {
  Result error() => Result.error(this);
}

extension ResultCasting<T> on Result<T> {
  Ok<T> get asOk => this as Ok<T>;

  Error<T> get asError => this as Error<T>;
}

extension ResultFolt<T> on Result<T> {
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Exception error) onFailure,
  }) {
    if (isSuccess) return onSuccess((this as Ok<T>).value);
    return onFailure((this as Error<T>).error);
  }
}
