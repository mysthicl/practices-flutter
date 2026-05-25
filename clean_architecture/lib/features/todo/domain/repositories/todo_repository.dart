import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/todo.dart';

/// Contrato abstracto — la capa Data lo implementará
abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
  Future<Either<Failure, Todo>> addTodo(Todo todo);
  Future<Either<Failure, Todo>> updateTodo(Todo todo);
  Future<Either<Failure, String>> deleteTodo(String id);
}