import 'dart:core';

class SimpleException implements Exception {
  final String message;

  SimpleException(this.message);

  @override
  String toString() {
    return message;
  }
}