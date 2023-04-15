part of 'todo_cubit.dart';

class TodoState extends Equatable {
  const TodoState({
    this.todos = const <TodoModel>[],
    required this.todoForm,
  });

  final List<TodoModel> todos;
  final TodoForm todoForm;

  @override
  List<Object?> get props => [todos];

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
