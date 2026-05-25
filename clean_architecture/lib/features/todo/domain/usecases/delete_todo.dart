import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

class DeleteTodo implements UseCase<String, DeleteTodoParams> {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  @override
  Future<Either<Failure, String>> call(DeleteTodoParams params) async {
    return await repository.deleteTodo(params.id);
  }
}

class DeleteTodoParams {
  final String id;
  const DeleteTodoParams({required this.id});
}