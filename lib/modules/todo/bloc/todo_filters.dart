// ignore_for_file: one_member_abstracts

import 'package:premium_todo/modules/todo/todo.dart';

abstract class TodoFilter {
  List<TodoModel> filterList(List<TodoModel> todos);
}

class TodoFilterAll implements TodoFilter {
  @override
  List<TodoModel> filterList(List<TodoModel> todos) {
    return todos;
  }
}

class TodoFilterPending implements TodoFilter {
  @override
  List<TodoModel> filterList(List<TodoModel> todos) {
    return todos.where((todo) => todo.status == TodoStatus.pending).toList();
  }
}

class TodoFilterDone implements TodoFilter {
  @override
  List<TodoModel> filterList(List<TodoModel> todos) {
    return todos.where((todo) => todo.status == TodoStatus.done).toList();
  }
}
