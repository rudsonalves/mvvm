abstract interface class Result<T> {
  const Result();

  factory Result.ok(T value) = Ok._;

  factory Result.error(Exception error) = Error._;

  // TearsOff
  // factory Result.ok(T value) => Ok._(value);

  // factory Result.error(Exception error) => Error._(error);
}

final class Ok<T> implements Result<T> {
  final T value;

  Ok._(this.value);
}

final class Error<T> implements Result<T> {
  final Exception error;

  Error._(this.error);
}

extension ResultExtension on Object {
  Result ok() {
    return Result.ok(this);
  }
}

extension ResultException on Exception {
  Result error() => Result.error(this);
}

extension ResultCasting<T> on Result<T> {
  Ok<T> get asOk => this as Ok<T>;

  Error<T> get asError => this as Error<T>;
}
