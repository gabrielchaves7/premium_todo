part of 'todo_bloc.dart';

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

class TodoState extends Equatable {
  const TodoState({
    this.todos = const <TodoModel>[],
    required this.todoForm,
    required this.todoFilter,
    this.currentPage = 0,
  });

  final List<TodoModel> todos;
  final TodoForm todoForm;
  final TodoFilter todoFilter;
  final int currentPage;

  @override
  List<Object?> get props => [todos, todoForm, todoFilter, currentPage];

  TodoState copyWith({
    List<TodoModel>? newTodos,
    TodoForm? newTodoForm,
    TodoFilter? newTodofilter,
    int? newCurrentPage,
  }) {
    return TodoState(
      todos: newTodos ?? todos,
      todoForm: newTodoForm ?? todoForm,
      todoFilter: newTodofilter ?? todoFilter,
      currentPage: newCurrentPage ?? currentPage,
    );
  }
}
