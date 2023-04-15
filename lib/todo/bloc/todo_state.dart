part of 'todo_bloc.dart';

class TodoState extends Equatable {
  const TodoState({
    this.todos = const <TodoModel>[],
    required this.todoForm,
  });

  final List<TodoModel> todos;
  final TodoForm todoForm;

  @override
  List<Object?> get props => [todos, todoForm];

  TodoState copyWith({
    List<TodoModel>? newTodos,
    TodoForm? newTodoForm,
  }) {
    return TodoState(
      todos: newTodos ?? todos,
      todoForm: newTodoForm ?? todoForm,
    );
  }
}
