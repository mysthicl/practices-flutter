import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/todo/data/datasources/todo_local_datasource.dart';
import 'features/todo/data/repositories/todo_repository_impl.dart';
import 'features/todo/domain/repositories/todo_repository.dart';
import 'features/todo/domain/usecases/get_todos.dart';
import 'features/todo/domain/usecases/add_todo.dart';
import 'features/todo/domain/usecases/update_todo.dart';
import 'features/todo/domain/usecases/delete_todo.dart';
import 'features/todo/presentation/cubit/todo_cubit.dart';

final sl = GetIt.instance; // sl = service locator

Future<void> initDependencies() async {
  // ── Cubit ──────────────────────────────────────────────
  sl.registerFactory(() => TodoCubit(
        getTodos: sl(),
        addTodo: sl(),
        updateTodo: sl(),
        deleteTodo: sl(),
      ));

  // ── Use Cases ──────────────────────────────────────────
  sl.registerLazySingleton(() => GetTodos(sl()));
  sl.registerLazySingleton(() => AddTodo(sl()));
  sl.registerLazySingleton(() => UpdateTodo(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));

  // ── Repository ─────────────────────────────────────────
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(localDataSource: sl()),
  );

  // ── Data Sources ───────────────────────────────────────
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ── Externos ───────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
}