// ignore_for_file: strict_raw_type

import 'package:dartz/dartz.dart';
import 'package:premium_todo/bootstrap.dart';
import 'package:premium_todo/todo/errors/todo_errors.dart';
import 'package:premium_todo/todo/model/todo_model.dart';
import 'package:premium_todo/todo/shared_preferences.dart';

class TodoRepository {
  TodoRepository({DataSource? dataSource}) {
    _dataSource = dataSource ?? getIt<DataSource>();
  }
  late final DataSource _dataSource;

  Future<Either<Failure, bool>> addTodo(List<TodoModel> todos) async {
    try {
      final response =
          await _dataSource.saveList('todos', TodoModel.toStringList(todos));
      return Right(response);
    } catch (e) {
      return Left(CreateTodoFailure());
    }
  }

  Future<Either<Failure, List<TodoModel>>> getTodos() async {
    try {
      final response = _dataSource.getList('todos');

      return Right(TodoModel.fromStringList(response));
    } catch (e) {
      return Left(CreateTodoFailure());
    }
  }
}
