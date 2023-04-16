part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateTodo extends TodoEvent {}

class NameChanged extends TodoEvent {
  NameChanged({required this.name});
  final String name;
}

class GetTodos extends TodoEvent {}

class UpdateTodoStatus extends TodoEvent {
  UpdateTodoStatus({required this.id, required this.newStatus});
  final String id;
  final TodoStatus newStatus;
}

class ChangeTodoFilter extends TodoEvent {
  ChangeTodoFilter({required this.todoFilter, required this.newCurrentPage});
  final TodoFilter todoFilter;
  final int newCurrentPage;
}

class DeleteTodo extends TodoEvent {
  DeleteTodo({required this.id});
  final String id;
}
