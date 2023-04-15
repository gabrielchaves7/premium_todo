abstract class Failure {
  Failure(this.message);
  final String message;
}

class CreateTodoFailure extends Failure implements Exception {
  CreateTodoFailure() : super('Ocorreu um erro ao criar sua todo!');
}
