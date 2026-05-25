import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/failures.dart';
import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> saveTodo(TodoModel todo);
  Future<TodoModel> updateTodo(TodoModel todo);
  Future<String> deleteTodo(String id);
}

const String _todosKey = 'TODOS_KEY';

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final SharedPreferences sharedPreferences;

  TodoLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TodoModel>> getTodos() async {
    final jsonString = sharedPreferences.getString(_todosKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((json) => TodoModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TodoModel> saveTodo(TodoModel todo) async {
    final todos = await getTodos();
    todos.add(todo);
    await _saveTodoList(todos);
    return todo;
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo) async {
    final todos = await getTodos();
    final index = todos.indexWhere((t) => t.id == todo.id);

    if (index == -1) {
      throw const CacheFailure(message: 'Tarea no encontrada');
    }

    todos[index] = todo;
    await _saveTodoList(todos);
    return todo;
  }

  @override
  Future<String> deleteTodo(String id) async {
    final todos = await getTodos();
    todos.removeWhere((t) => t.id == id);
    await _saveTodoList(todos);
    return id;
  }

  Future<void> _saveTodoList(List<TodoModel> todos) async {
    final jsonList = todos.map((t) => t.toJson()).toList();
    await sharedPreferences.setString(_todosKey, json.encode(jsonList));
  }
}