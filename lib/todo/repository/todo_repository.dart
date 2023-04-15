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

  Future<Either<Failure, bool>> createTodo(TodoModel todo) async {
    try {
      final response = await _dataSource.saveMap('todos', todo.toJson());
      return Right(response);
    } catch (e) {
      return Left(CreateTodoFailure());
    }
  }
}
