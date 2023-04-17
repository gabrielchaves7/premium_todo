import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_todo/design_system/atoms/dialog.dart';
import 'package:premium_todo/design_system/atoms/ds_snackbar.dart';
import 'package:premium_todo/todo/bloc/todo_bloc.dart';
import 'package:premium_todo/todo/view/todo_dialog.dart';
import 'package:premium_todo/todo/view/todo_filters.dart';
import 'package:premium_todo/todo/view/todo_list.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TodoView();
  }
}

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    context.read<TodoBloc>().add(GetTodos());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To do list')),
      body: BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state.dsSnackbarType != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              DsSnackBar.getSnackBar(state.dsSnackbarType!),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const TodoFilters(),
              TodoList(
                listKey: listKey,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              return FloatingActionButton(
                onPressed: () => openDialog(
                  context: context,
                  widget: TodoDialog(
                    todoBloc: context.read<TodoBloc>(),
                    onEventSuccess: () {
                      listKey.currentState!.insertItem(state.todos.length);
                    },
                  ),
                ),
                child: const Icon(Icons.add),
              );
            },
          ),
        ],
      ),
    );
  }
}
