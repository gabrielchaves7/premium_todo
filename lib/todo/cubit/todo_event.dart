part of 'todo_cubit.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateTodo extends TodoEvent {}

class NameChanged extends TodoEvent {
  NameChanged({required this.name});
  final String name;
}
