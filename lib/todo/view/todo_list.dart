import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_todo/design_system/atoms/dialog.dart';
import 'package:premium_todo/design_system/molecules/ds_checkbox_tile.dart';
import 'package:premium_todo/todo/bloc/todo_bloc.dart';
import 'package:premium_todo/todo/model/todo_model.dart';
import 'package:premium_todo/todo/view/todo_dialog.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        Widget widget = const CircularProgressIndicator();
        final todos = context.read<TodoBloc>().state.todoFilter.filterList(
              state.todos,
            );

        if (todos.isNotEmpty) {
          widget = Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                final isChecked = todo.status == TodoStatus.done;
                return DsCheckboxTile(
                  title: todo.name,
                  value: isChecked,
                  onChanged: (value) {
                    context.read<TodoBloc>().add(
                          UpdateTodoStatus(
                            index: index,
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
