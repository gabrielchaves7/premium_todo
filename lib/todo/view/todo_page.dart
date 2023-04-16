import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_todo/design_system/molecules/ds_checkbox_tile.dart';
import 'package:premium_todo/design_system/molecules/ds_tab.dart';
import 'package:premium_todo/design_system/molecules/ds_text_form_field.dart';
import 'package:premium_todo/todo/bloc/todo_bloc.dart';
import 'package:premium_todo/todo/model/todo_model.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoBloc(),
      child: const TodoView(),
    );
  }
}

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  @override
  void initState() {
    context.read<TodoBloc>().add(GetTodos());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To do list')),
      body: Column(
        children: [
          TodoFilters(),
          const TodoList(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<TodoBloc>()..add(CreateTodo()),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
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
              );
            },
          ),
        );
      }

      return widget;
    });
  }
}

class TodoFilters extends StatelessWidget {
  const TodoFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        final currentPage = state.currentPage;
        return Row(
          children: [
            Expanded(
              child: DsTab(
                text: 'All',
                type: _tabType(currentPage, 0),
                onPressed: () {
                  _updateFilter(context, TodoFilterAll(), 0);
                },
              ),
            ),
            Expanded(
              child: DsTab(
                text: 'pending',
                type: _tabType(currentPage, 1),
                onPressed: () {
                  _updateFilter(context, TodoFilterPending(), 1);
                },
              ),
            ),
            Expanded(
              child: DsTab(
                text: 'done',
                type: _tabType(currentPage, 2),
                onPressed: () {
                  _updateFilter(context, TodoFilterDone(), 2);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateFilter(
    BuildContext context,
    TodoFilter filter,
    int newCurrentPage,
  ) {
    context.read<TodoBloc>().add(
          ChangeTodoFilter(todoFilter: filter, newCurrentPage: newCurrentPage),
        );
  }

  TabType _tabType(int currentPage, int index) {
    var tabType = TabType.unselected;
    if (currentPage == index) tabType = TabType.selected;

    return tabType;
  }
}
