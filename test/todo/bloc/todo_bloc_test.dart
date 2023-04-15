import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:premium_todo/todo/bloc/todo_bloc.dart';
import 'package:premium_todo/todo/forms/todo_form.dart';
import 'package:premium_todo/todo/model/todo_model.dart';

import '../todos_test.dart';

void main() {
  group('TodoBloc', () {
    blocTest<TodoBloc, TodoState>(
      'should add new todo to array when CreateTodo is called',
      build: () {
        final mockedAddTodoUc = MockAddTodoUC();
        when(
          () => mockedAddTodoUc.call([
            TodoModel(
              name: 'Teste',
            )
          ]),
        ).thenAnswer(
          (_) async => right(true),
        );
        final todoBloc = mockTodoBloc(addTodoUC: mockedAddTodoUc);
        todoBloc.state.todoForm.name = const NameInput.dirty(value: 'Teste');

        return todoBloc;
      },
      act: (bloc) => bloc.add(CreateTodo()),
      verify: (_) {
        expect(_.state.todos.length, 1);
      },
    );

    blocTest<TodoBloc, TodoState>(
      'should update name input when NameChanged is called',
      build: mockTodoBloc,
      act: (bloc) => bloc.add(NameChanged(name: 'Teste')),
      verify: (_) {
        expect(_.state.todoForm.name.value, 'Teste');
      },
    );

    blocTest<TodoBloc, TodoState>(
      'should update todos when GetTodos is called',
      build: () {
        final mockGetTodosUC = MockGetTodosUC();
        when(mockGetTodosUC.call).thenAnswer(
          (_) async => right([TodoModel(name: 'Teste')]),
        );

        return mockTodoBloc(getTodosUC: mockGetTodosUC);
      },
      act: (bloc) => bloc.add(GetTodos()),
      verify: (_) {
        expect(_.state.todos.length, 1);
      },
    );

    blocTest<TodoBloc, TodoState>(
      'should update todos when UpdateTodoStatus is called',
      build: () {
        final mockedAddTodoUc = MockAddTodoUC();
        final mockGetTodosUC = MockGetTodosUC();
        when(
          () => mockedAddTodoUc
              .call([TodoModel(name: 'Teste', status: TodoStatus.done)]),
        ).thenAnswer(
          (_) async => right(true),
        );
        when(mockGetTodosUC.call).thenAnswer(
          (_) async => right([TodoModel(name: 'Teste')]),
        );

        return mockTodoBloc(
          getTodosUC: mockGetTodosUC,
          addTodoUC: mockedAddTodoUc,
        );
      },
      act: (bloc) {
        bloc
          ..add(GetTodos())
          ..add(UpdateTodoStatus(newStatus: TodoStatus.done, index: 0));
      },
      verify: (_) {
        expect(_.state.todos.first.status, TodoStatus.done);
      },
    );
  });
}
