import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_todo/design_system/molecules/ds_text_form_field.dart';
import 'package:premium_todo/todo/bloc/todo_bloc.dart';

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
      appBar: AppBar(title: const Text('Titulo')),
      body: const Center(child: CounterText()),
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

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DSTextField(
          label: 'Nome',
          onChanged: (value) =>
              context.read<TodoBloc>()..add(NameChanged(name: value)),
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
                    return ListTile(title: Text(todo.name));
                  },
                ),
              );
            }

            return widget;
          },
        ),
      ],
    );
  }
}
