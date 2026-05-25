import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';
import '../../domain/entities/todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  void initState() {
    super.initState();
    context.read<TodoCubit>().loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TodoError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message, textAlign: TextAlign.center),
                  ElevatedButton(
                    onPressed: () => context.read<TodoCubit>().loadTodos(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.checklist, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No tienes tareas aún.\n¡Agrega una!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Sección: Pendientes
                if (state.pendingTodos.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Pendientes (${state.pendingTodos.length})',
                    color: Colors.orange,
                  ),
                  ...state.pendingTodos.map((todo) => _TodoCard(todo: todo)),
                ],
                // Sección: Completadas
                if (state.completedTodos.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _SectionHeader(
                    title: 'Completadas (${state.completedTodos.length})',
                    color: Colors.green,
                  ),
                  ...state.completedTodos.map((todo) => _TodoCard(todo: todo)),
                ],
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTodoDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva Tarea'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título *',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isEmpty) return;
              context.read<TodoCubit>().createTodo(
                    title: title,
                    description: descController.text.trim().isEmpty
                        ? null
                        : descController.text.trim(),
                  );
              Navigator.pop(ctx);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(width: 4, height: 20, color: color,
              margin: const EdgeInsets.only(right: 8)),
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 14)),
        ],
      ),
    );
  }
}

class _TodoCard extends StatelessWidget {
  final Todo todo;

  const _TodoCard({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => context.read<TodoCubit>().toggleTodo(todo),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: todo.description != null
            ? Text(todo.description!,
                style: const TextStyle(fontSize: 12))
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _showEditDialog(context, todo),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () => _confirmDelete(context, todo),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Todo todo) {
    final titleCtrl = TextEditingController(text: todo.title);
    final descCtrl = TextEditingController(text: todo.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Tarea'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                  labelText: 'Título', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(
                  labelText: 'Descripción', border: OutlineInputBorder()),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final newTitle = titleCtrl.text.trim();
              if (newTitle.isEmpty) return;
              context.read<TodoCubit>().editTodo(
                    todo: todo,
                    newTitle: newTitle,
                    newDescription: descCtrl.text.trim().isEmpty
                        ? null
                        : descCtrl.text.trim(),
                  );
              Navigator.pop(ctx);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Deseas eliminar "${todo.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<TodoCubit>().removeTodo(todo.id);
              Navigator.pop(ctx);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}