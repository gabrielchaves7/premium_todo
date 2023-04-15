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
  late final PageController pageController;
  late int currentPage;

  @override
  void initState() {
    context.read<TodoBloc>().add(GetTodos());
    pageController = PageController();
    currentPage = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To do list')),
      body: Column(
        children: [
          TodoFilters(
            currentPage: currentPage,
            pageController: pageController,
          ),
          SizedBox(
            height: 400,
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() => currentPage = value);
              },
              children: <Widget>[
                Column(
                  children: [
                    DSTextField(
                      label: 'Nome',
                      onChanged: (value) => context.read<TodoBloc>()
                        ..add(NameChanged(name: value)),
                    ),
                    BlocBuilder<TodoBloc, TodoState>(
                      builder: (context, state) {
                        Widget widget = const CircularProgressIndicator();
                        final todos = state.todos;

                        if (todos.isNotEmpty) {
                          widget = Expanded(
                            child: ListView.builder(
                              itemCount: todos.length,
                              itemBuilder: (context, index) {
                                final todo = todos[index];
                                final isChecked =
                                    todo.status == TodoStatus.done;
                                return DsCheckboxTile(
                                  title: todo.name,
                                  value: isChecked,
                                  onChanged: (value) {
                                    context.read<TodoBloc>().add(
                                          UpdateTodoStatus(
                                            index: index,
                                            newStatus: value!
                                                ? TodoStatus.done
                                                : TodoStatus.pending,
                                          ),
                                        );
                                  },
                                );
                              },
                            ),
                          );
                        }

                        return widget;
                      },
                    ),
                  ],
                ),
                const Center(
                  child: Text('Second Page'),
                ),
                const Center(
                  child: Text('Third Page'),
                ),
              ],
            ),
          ),
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

class TodoFilters extends StatelessWidget {
  const TodoFilters({
    required this.currentPage,
    required this.pageController,
    super.key,
  });
  final int currentPage;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DsTab(
            text: 'All',
            type: _tabType(0),
            onPressed: () {
              _animateToPage(0);
            },
          ),
        ),
        Expanded(
          child: DsTab(
            text: 'pending',
            type: _tabType(1),
            onPressed: () {
              _animateToPage(1);
            },
          ),
        ),
        Expanded(
          child: DsTab(
            text: 'done',
            type: _tabType(2),
            onPressed: () {
              _animateToPage(2);
            },
          ),
        ),
      ],
    );
  }

  TabType _tabType(int index) {
    var tabType = TabType.unselected;
    if (currentPage == index) tabType = TabType.selected;

    return tabType;
  }

  void _animateToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(seconds: 1),
      curve: Curves.linear,
    );
  }
}
