import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:premium_todo/todo/forms/todo_form.dart';
import 'package:premium_todo/todo/model/todo_model.dart';

import 'package:premium_todo/todo/todo.dart';

import '../../helpers/helpers.dart';
import '../todos_test.dart';

void main() {
  group('TodoView', () {
    testWidgets('should render todos list', (tester) async {
      final getTodosUC = mockGetTodosUC(
          [TodoModel(name: 'Todo 1'), TodoModel(name: 'Todo 2')]);
      final todoBloc = mockTodoBloc(getTodosUC: getTodosUC);

      await tester.pumpApp(
        BlocProvider.value(
          value: todoBloc,
          child: const TodoView(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Todo 1'), findsOneWidget);
      expect(find.text('Todo 2'), findsOneWidget);
    });
  });
}
