import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../models/todo_model.dart';

/// Implementación concreta del repositorio abstracto
class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final todos = await localDataSource.getTodos();
      return Right(todos);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Todo>> addTodo(Todo todo) async {
    try {
      final model = TodoModel.fromEntity(todo);
      final saved = await localDataSource.saveTodo(model);
      return Right(saved);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(Todo todo) async {
    try {
      final model = TodoModel.fromEntity(todo);
      final updated = await localDataSource.updateTodo(model);
      return Right(updated);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteTodo(String id) async {
    try {
      final deletedId = await localDataSource.deleteTodo(id);
      return Right(deletedId);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}