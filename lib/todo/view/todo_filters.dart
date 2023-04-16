import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_todo/design_system/molecules/ds_tab.dart';
import 'package:premium_todo/todo/bloc/todo_bloc.dart';

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
                tabBorderStyle: TabBorderStyle.leftRounded,
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
                tabBorderStyle: TabBorderStyle.rightRounded,
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
