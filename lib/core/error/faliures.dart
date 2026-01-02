import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}


class LocalDatabaseFilure extends Failure{
  const LocalDatabaseFilure({
    String message =" local database operation faliled",

  }):super(message);
}


class ApiFailure extends Failure{
  final int? statusCode;

  const ApiFailure({
    this.statusCode,
    required String message
  }):super(message);
}