import '../../domain/entities/todo.dart';

/// Extiende la Entidad y añade serialización JSON
class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.title,
    super.description,
    required super.isCompleted,
    required super.createdAt,
  });

  /// Convierte un Map (JSON) → TodoModel
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convierte TodoModel → Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Convierte una Entidad Todo → TodoModel
  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: todo.isCompleted,
      createdAt: todo.createdAt,
    );
  }
}