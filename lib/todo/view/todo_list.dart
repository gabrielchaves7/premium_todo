import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_todo/design_system/atoms/dialog.dart';
import 'package:premium_todo/design_system/atoms/spacing.dart';
import 'package:premium_todo/design_system/atoms/text_styles.dart';
import 'package:premium_todo/design_system/molecules/ds_checkbox_tile.dart';
import 'package:premium_todo/todo/bloc/todo_bloc.dart';
import 'package:premium_todo/todo/model/todo_model.dart';
import 'package:premium_todo/todo/view/todo_dialog.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key, required this.listKey});
  final GlobalKey<AnimatedListState> listKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        Widget widget = Padding(
          padding: const EdgeInsets.symmetric(vertical: DsSpacing.xxxx),
          child: const Text('There is nothing to show here yet.').headingSmall,
        );
        final todos = context.read<TodoBloc>().state.todoFilter.filterList(
              state.todos,
            );

        if (state.loading) {
          widget = const Center(child: CircularProgressIndicator());
        } else if (todos.isNotEmpty) {
          widget = Expanded(
            child: AnimatedList(
              key: listKey,
              initialItemCount: todos.length,
              itemBuilder: (context, index, animation) {
                final todo = todos[index];
                final isChecked = todo.status == TodoStatus.done;

                return SizeTransition(
                  sizeFactor: animation,
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
                            onEventSuccess: () {
                              listKey.currentState!.removeItem(
                                index,
                                (context, animation) => DsCheckboxTile(
                                    title: todo.name, value: isChecked),
                              );
                            },
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
