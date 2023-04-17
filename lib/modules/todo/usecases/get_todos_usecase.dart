import 'package:dartz/dartz.dart';
import 'package:premium_todo/bootstrap.dart';
import 'package:premium_todo/modules/todo/todo.dart';

class GetTodosUC {
  GetTodosUC({TodoRepository? todoRepository}) {
    _todoRepository = todoRepository ?? getIt<TodoRepository>();
  }
  late final TodoRepository _todoRepository;

  Future<Either<Failure, List<TodoModel>>> call() async {
    return _todoRepository.getTodos();
  }
}
