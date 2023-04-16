import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:premium_todo/todo/model/todo_model.dart';

import 'package:premium_todo/todo/todo.dart';

import '../../helpers/helpers.dart';
import '../todos_test.dart';

void main() {
  group('TodoView', () {
    testWidgets('should render todos list', (tester) async {
      final getTodosUC = mockGetTodosUC(
        [
          TodoModel(id: '1', name: 'Todo 1'),
          TodoModel(id: '2', name: 'Todo 2')
        ],
      );
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
      expect(find.text('All'), findsOneWidget);
      expect(find.text('pending'), findsOneWidget);
      expect(find.text('done'), findsOneWidget);
    });

    testWidgets('should filter todos when filter change', (tester) async {
      final getTodosUC = mockGetTodosUC(
        [
          TodoModel(id: '1', name: 'Todo 1'),
          TodoModel(id: '2', name: 'Todo 2', status: TodoStatus.done)
        ],
      );
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

      await tester.tap(find.text('pending'));
      await tester.pump();

      expect(find.text('Todo 1'), findsOneWidget);
      expect(find.text('Todo 2'), findsNothing);
    });

    testWidgets('should add todo to list', (tester) async {
      final todos = [
        TodoModel(id: '1', name: 'Todo 1'),
        TodoModel(id: '2', name: 'Todo 2', status: TodoStatus.done)
      ];
      final getTodosUC = mockGetTodosUC(todos);
      final addTodoUC = mockAddTodoUC(
        newTodos: [...todos, TodoModel(id: '3', name: 'Todo 3')],
        result: true,
      );
      final todoBloc = mockTodoBloc(
        getTodosUC: getTodosUC,
        addTodoUC: addTodoUC,
      );

      await tester.pumpApp(
        BlocProvider(
          create: (_) => todoBloc,
          child: const MaterialApp(
            home: TodoView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Todo 3'), findsNothing);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'Todo 3');
      await tester.pump();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Todo 3'), findsOneWidget);
    });

    testWidgets('should delete todo from list', (tester) async {
      final todo = TodoModel(id: '1', name: 'Todo 1');
      final getTodosUC = mockGetTodosUC([todo]);
      final deleteTodoUC = mockDeleteTodoUC(newTodos: [], result: true);
      final todoBloc = mockTodoBloc(
        getTodosUC: getTodosUC,
        deleteTodoUC: deleteTodoUC,
      );

      await tester.pumpApp(
        BlocProvider(
          create: (_) => todoBloc,
          child: const MaterialApp(
            home: TodoView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Todo 1'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Open dialog to delete todo'));
      await tester.pump();
      await tester.tap(find.text('Delete'));
      await tester.pump();

      expect(find.text('Todo 1'), findsNothing);
    });
  });
}
