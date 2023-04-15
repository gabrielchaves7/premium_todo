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
  UpdateTodoStatus({required this.name, required this.newStatus});
  final String name;
  final TodoStatus newStatus;
}
