import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:premium_todo/modules/todo/todo.dart';

class MockAddTodoUC extends Mock implements AddTodoUC {}

class MockGetTodosUC extends Mock implements GetTodosUC {}

class MockDeleteTodoUC extends Mock implements DeleteTodoUC {}

class MockTodoBloc extends Mock implements TodoBloc {}

void main() {}

TodoBloc mockTodoBloc({
  AddTodoUC? addTodoUC,
  GetTodosUC? getTodosUC,
  DeleteTodoUC? deleteTodoUC,
}) {
  return TodoBloc(
    addTodoUC: addTodoUC ?? MockAddTodoUC(),
    getTodos: getTodosUC ?? MockGetTodosUC(),
    deleteTodoUC: deleteTodoUC ?? MockDeleteTodoUC(),
  );
}

MockGetTodosUC mockGetTodosUC(List<TodoModel> todos) {
  final mockGetTodosUC = MockGetTodosUC();
  when(mockGetTodosUC.call).thenAnswer(
    (_) async => right(todos),
  );

  return mockGetTodosUC;
}

MockAddTodoUC mockAddTodoUC({
  required List<TodoModel> newTodos,
  required bool result,
}) {
  final mockAddTodoUC = MockAddTodoUC();
  when(() => mockAddTodoUC.call(newTodos)).thenAnswer(
    (_) async => right(result),
  );

  return mockAddTodoUC;
}

MockDeleteTodoUC mockDeleteTodoUC({
  required List<TodoModel> newTodos,
  required bool result,
}) {
  final mockDeleteTodoUC = MockDeleteTodoUC();
  when(() => mockDeleteTodoUC.call(newTodos)).thenAnswer(
    (_) async => right(result),
  );

  return mockDeleteTodoUC;
}
