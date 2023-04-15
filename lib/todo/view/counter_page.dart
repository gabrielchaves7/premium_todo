import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_todo/design_system/molecules/ds_text_form_field.dart';
import 'package:premium_todo/todo/todo.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

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
            onPressed: () => context.read<TodoCubit>()..add(CreateTodo()),
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
              context.read<TodoCubit>()..add(NameChanged(name: value)),
        ),
        BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state) => Wrap(
            children: [
              for (final todo in state.todos) Text(todo.name),
            ],
          ),
        ),
      ],
    );
  }
}
