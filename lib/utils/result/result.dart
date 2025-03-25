// Copyright 2025 Rudson Alves. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Based in The Flutter team result:
// https://github.com/flutter/samples/blob/main/compass_app/app/lib/utils/result.dart

/// Utility class to wrap result data
///
/// Evaluate the result using a fold statement:
/// ```dart
/// result.fold(
///   onOk: (value) {
///     print(value);
///   },
///   onError: (err) {
///     print(error)
///   }
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// Creates a successful [Result], completed with the specified [value].
  const factory Result.ok(T value) = Ok<T>._;

  /// Creates an error [Result], completed with the specified [error].
  const factory Result.error(Exception error) = Error<T>._;

  /// Returned true if is Ok
  bool get isOk => this is Ok<T>;

  /// Returned true id is error
  bool get isError => this is Error<T>;

  /// Pattern-matching handler for [Result].
  R fold<R>({
    required R Function(T value) onOk,
    required R Function(Exception error) onError,
  }) {
    return switch (this) {
      Ok<T> ok => onOk(ok.value),
      Error<T> error => onError(error.error),
    };
  }
}

/// A successful [Result] wrapping a [value].
final class Ok<T> extends Result<T> {
  const Ok._(this.value);
  final T value;
}

/// A failed [Result] wrapping an [Exception].
final class Error<T> extends Result<T> {
  const Error._(this.error);
  final Exception error;
}

/// Cast extensions to access typed [Ok] and [Error] results.
extension ResultCasting<T> on Result<T> {
  Ok<T> get asOk => this as Ok<T>;

  Error<T> get asError => this as Error<T>;
}
