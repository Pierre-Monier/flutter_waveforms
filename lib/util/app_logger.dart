import "package:logger/logger.dart";

abstract class AppLogger {
  static final _logger = Logger();

  static void v(
    message, [
    error,
    StackTrace? stackTrace,
  ]) {
    _logger.v(message, [error, stackTrace]);
  }

  static void d(
    message, [
    error,
    StackTrace? stackTrace,
  ]) {
    _logger.d(message, [error, stackTrace]);
  }

  static void i(
    message, [
    error,
    StackTrace? stackTrace,
  ]) {
    _logger.i(message, [error, stackTrace]);
  }

  static void w(
    message, [
    error,
    StackTrace? stackTrace,
  ]) {
    _logger.w(message, [error, stackTrace]);
  }

  static void e(
    message, [
    error,
    StackTrace? stackTrace,
  ]) {
    _logger.e(message, [error, stackTrace]);
  }

  static void wtf(
    message, [
    error,
    StackTrace? stackTrace,
  ]) {
    _logger.wtf(message, [error, stackTrace]);
  }
}
