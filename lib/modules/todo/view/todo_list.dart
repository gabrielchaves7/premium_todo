import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_todo/design_system/design_system.dart';
import 'package:premium_todo/modules/todo/todo.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        Widget widget = Padding(
          padding: const EdgeInsets.symmetric(vertical: DsSpacing.xxxx),
          child: const Text('There is nothing to show here yet.').headingSmall,
        );
        final todos = context.read<TodoBloc>().state.filteredTodos;

        if (state.loading) {
          widget = const Center(child: CircularProgressIndicator());
        } else if (todos.isNotEmpty) {
          widget = Expanded(
            child: AnimatedList(
              key: state.listKey,
              initialItemCount: todos.length,
              itemBuilder: (context, index, animation) {
                if (index > todos.length - 1) return Container();
                final todo = todos[index];
                final isChecked = todo.status == TodoStatus.done;

                return FadeTransition(
                  opacity: animation,
                  child: DsCheckboxTile(
                    title: todo.name,
                    value: isChecked,
                    onChanged: (value) {
                      context.read<TodoBloc>().add(
                            UpdateTodoStatus(
                              id: todo.id,
                              newStatus:
                                  value! ? TodoStatus.done : TodoStatus.pending,
                            ),
                          );
                    },
                    trailing: GestureDetector(
                      onTap: () async {
                        await openDialog(
                          context: context,
                          widget: TodoDialog(
                            isDelete: true,
                            todo: todo,
                            todoBloc: context.read<TodoBloc>(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.more_horiz,
                        semanticLabel: 'Open dialog to delete todo',
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        return widget;
      },
    );
  }
}
