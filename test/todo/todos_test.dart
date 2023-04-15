import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:premium_todo/todo/model/todo_model.dart';
import 'package:premium_todo/todo/todo.dart';
import 'package:premium_todo/todo/usecases/add_todo_usecase.dart';
import 'package:premium_todo/todo/usecases/get_todos_usecase.dart';

class MockCreateTodoUC extends Mock implements AddTodoUC {}

class MockGetTodosUC extends Mock implements GetTodosUC {}

class MockTodoBloc extends Mock implements TodoBloc {}

void main() {}

TodoBloc mockTodoBloc({AddTodoUC? addTodoUC, GetTodosUC? getTodosUC}) {
  return TodoBloc(
    addTodoUC: addTodoUC ?? MockCreateTodoUC(),
    getTodos: getTodosUC ?? MockGetTodosUC(),
  );
}

MockGetTodosUC mockGetTodosUC(List<TodoModel> todos) {
  final mockGetTodosUC = MockGetTodosUC();
  when(mockGetTodosUC.call).thenAnswer(
    (_) async => right(todos),
  );

  return mockGetTodosUC;
}
