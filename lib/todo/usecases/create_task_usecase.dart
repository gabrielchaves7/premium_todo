import 'package:dartz/dartz.dart';
import 'package:premium_todo/bootstrap.dart';
import 'package:premium_todo/todo/errors/todo_errors.dart';
import 'package:premium_todo/todo/model/todo_model.dart';
import 'package:premium_todo/todo/repository/todo_repository.dart';

class CreateTodoUC {
  CreateTodoUC({TodoRepository? todoRepository}) {
    _todoRepository = todoRepository ?? getIt<TodoRepository>();
  }
  late final TodoRepository _todoRepository;

  Future<Either<Failure, bool>> call(TodoModel todo) async {
    return _todoRepository.createTodo(todo);
  }
}
