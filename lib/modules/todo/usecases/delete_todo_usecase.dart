import 'package:dartz/dartz.dart';
import 'package:premium_todo/bootstrap.dart';
import 'package:premium_todo/modules/todo/todo.dart';

class DeleteTodoUC {
  DeleteTodoUC({TodoRepository? todoRepository}) {
    _todoRepository = todoRepository ?? getIt<TodoRepository>();
  }
  late final TodoRepository _todoRepository;

  Future<Either<Failure, bool>> call(List<TodoModel> todos) async {
    return _todoRepository.saveTodos(todos);
  }
}
