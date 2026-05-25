import 'package:equatable/equatable.dart';
import '../../domain/entities/todo.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

/// Estado inicial
class TodoInitial extends TodoState {}

/// Cargando datos
class TodoLoading extends TodoState {}

/// Datos cargados exitosamente
class TodoLoaded extends TodoState {
  final List<Todo> todos;

  const TodoLoaded({required this.todos});

  // Filtra solo las completadas
  List<Todo> get completedTodos => todos.where((t) => t.isCompleted).toList();

  // Filtra solo las pendientes
  List<Todo> get pendingTodos => todos.where((t) => !t.isCompleted).toList();

  @override
  List<Object> get props => [todos];
}

/// Error al operar
class TodoError extends TodoState {
  final String message;

  const TodoError({required this.message});

  @override
  List<Object> get props => [message];
}