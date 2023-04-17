abstract class Failure {
  Failure(this.message);
  final String message;
}

class CreateTodoFailure extends Failure implements Exception {
  CreateTodoFailure() : super('One error happened while creating a todo');
}

class GetTodosFailure extends Failure implements Exception {
  GetTodosFailure() : super('One error happened while getting todos');
}
