import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:premium_todo/todo/bloc/todo_bloc.dart';
import 'package:premium_todo/todo/forms/todo_form.dart';
import 'package:premium_todo/todo/model/todo_model.dart';

import '../todos_test.dart';

void main() {
  group('TodoBloc', () {
    blocTest<TodoBloc, TodoState>(
      'should add new todo to array when CreateTodo is called',
      build: () {
        final mockedAddTodoUc = mockAddTodoUC(
          newTodos: [
            TodoModel(
              name: 'Teste',
            )
          ],
          result: true,
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
        final mockedGetTodosUC = mockGetTodosUC([TodoModel(name: 'Teste')]);
        return mockTodoBloc(getTodosUC: mockedGetTodosUC);
      },
      act: (bloc) => bloc.add(GetTodos()),
      verify: (_) {
        expect(_.state.todos.length, 1);
      },
    );

    blocTest<TodoBloc, TodoState>(
      'should update todos when UpdateTodoStatus is called',
      build: () {
        final mockedAddTodoUc = mockAddTodoUC(
          newTodos: [TodoModel(name: 'Teste', status: TodoStatus.done)],
          result: true,
        );
        final mockedGetTodosUC = mockGetTodosUC([TodoModel(name: 'Teste')]);

        return mockTodoBloc(
          getTodosUC: mockedGetTodosUC,
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

    blocTest<TodoBloc, TodoState>(
      'should update todo filter when ChangeTodoFilter is called',
      build: () {
        final mockedGetTodosUC = mockGetTodosUC([
          TodoModel(name: 'Teste 1', status: TodoStatus.done),
          TodoModel(name: 'Teste 2')
        ]);

        return mockTodoBloc(getTodosUC: mockedGetTodosUC);
      },
      act: (bloc) {
        bloc
          ..add(GetTodos())
          ..add(
            ChangeTodoFilter(
              newCurrentPage: 1,
              todoFilter: TodoFilterPending(),
            ),
          );
      },
      verify: (_) {
        final filteredTodos = _.state.todoFilter.filterList(_.state.todos);
        expect(filteredTodos.length, 1);
        expect(_.state.currentPage, 1);
        expect(filteredTodos.first.status, TodoStatus.pending);
      },
    );

    blocTest<TodoBloc, TodoState>(
      'should remove todo from array when DeleteTodo is called',
      build: () {
        final mockedDeleteTodoUC = mockDeleteTodoUC(newTodos: [], result: true);
        final mockedGetTodos = mockGetTodosUC([TodoModel(name: 'Todo 1')]);

        final todoBloc = mockTodoBloc(
          deleteTodoUC: mockedDeleteTodoUC,
          getTodosUC: mockedGetTodos,
        );

        return todoBloc;
      },
      act: (bloc) => bloc
        ..add(GetTodos())
        ..add(DeleteTodo(name: 'Todo 1')),
      verify: (_) {
        expect(_.state.todos.length, 0);
      },
    );
  });
}
