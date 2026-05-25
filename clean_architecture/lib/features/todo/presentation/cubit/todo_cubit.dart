import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/update_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;

  final _uuid = const Uuid();

  TodoCubit({
    required this.getTodos,
    required this.addTodo,
    required this.updateTodo,
    required this.deleteTodo,
  }) : super(TodoInitial());

  /// Carga todas las tareas
  Future<void> loadTodos() async {
    emit(TodoLoading());
    final result = await getTodos(NoParams());
    result.fold(
      (failure) => emit(TodoError(message: failure.message)),
      (todos) => emit(TodoLoaded(todos: todos)),
    );
  }

  /// Agrega una nueva tarea
  Future<void> createTodo({
    required String title,
    String? description,
  }) async {
    final newTodo = Todo(
      id: _uuid.v4(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    final result = await addTodo(AddTodoParams(todo: newTodo));
    result.fold(
      (failure) => emit(TodoError(message: failure.message)),
      (_) => loadTodos(),
    );
  }

  /// Alterna el estado completado/pendiente de una tarea
  Future<void> toggleTodo(Todo todo) async {
    final updated = todo.copyWith(isCompleted: !todo.isCompleted);
    final result = await updateTodo(UpdateTodoParams(todo: updated));
    result.fold(
      (failure) => emit(TodoError(message: failure.message)),
      (_) => loadTodos(),
    );
  }

  /// Edita el título o descripción de una tarea
  Future<void> editTodo({
    required Todo todo,
    required String newTitle,
    String? newDescription,
  }) async {
    final updated = todo.copyWith(
      title: newTitle,
      description: newDescription,
    );
    final result = await updateTodo(UpdateTodoParams(todo: updated));
    result.fold(
      (failure) => emit(TodoError(message: failure.message)),
      (_) => loadTodos(),
    );
  }

  /// Elimina una tarea por ID
  Future<void> removeTodo(String id) async {
    final result = await deleteTodo(DeleteTodoParams(id: id));
    result.fold(
      (failure) => emit(TodoError(message: failure.message)),
      (_) => loadTodos(),
    );
  }
}