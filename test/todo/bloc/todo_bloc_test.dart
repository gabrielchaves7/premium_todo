import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:premium_todo/todo/bloc/todo_bloc.dart';
import 'package:premium_todo/todo/forms/todo_form.dart';
import 'package:premium_todo/todo/model/todo_model.dart';
import 'package:premium_todo/todo/usecases/create_task_usecase.dart';

class MockCreateTodoUC extends Mock implements CreateTodoUC {}

void main() {
  setUpAll(() {
    registerFallbackValue(TodoModel('a', 'a'));
  });
  group('TodoBloc', () {
    blocTest<TodoBloc, TodoState>(
      'should add new todo to array when createTodo is called',
      build: () {
        final mockedTodoUc = MockCreateTodoUC();
        when(() => mockedTodoUc.call(any())).thenAnswer(
          (_) async => right(true),
        );
        final todoBloc = TodoBloc(createTodoUC: mockedTodoUc);
        todoBloc.state.todoForm.name = const NameInput.dirty(value: 'Teste');

        return todoBloc;
      },
      act: (bloc) => bloc.add(CreateTodo()),
      verify: (_) {
        expect(_.state.todos.length, 1);
      },
    );

    blocTest<TodoBloc, TodoState>(
      'should update name input when nameChanged is called',
      build: () {
        final mockedTodoUc = MockCreateTodoUC();
        final todoBloc = TodoBloc(createTodoUC: mockedTodoUc);

        return todoBloc;
      },
      act: (bloc) => bloc.add(NameChanged(name: 'Teste')),
      verify: (_) {
        expect(_.state.todoForm.name.value, 'Teste');
      },
    );
  });
}
