// ignore_for_file: one_member_abstracts

part of 'todo_bloc.dart';

class TodoState extends Equatable {
  const TodoState({
    this.todos = const <TodoModel>[],
    required this.todoForm,
    required this.todoFilter,
    required this.listKey,
    this.currentPage = 0,
    this.dsSnackbarType,
    this.loading = false,
    this.previousFilteredTodos = const <TodoModel>[],
    this.filteredTodos = const <TodoModel>[],
  });

  final List<TodoModel> todos;
  final TodoForm todoForm;
  final TodoFilter todoFilter;
  final int currentPage;
  final DsSnackbarType? dsSnackbarType;
  final bool loading;
  final GlobalKey<AnimatedListState> listKey;
  final List<TodoModel> previousFilteredTodos;
  final List<TodoModel> filteredTodos;

  @override
  List<Object?> get props => [
        todos,
        todoForm,
        todoFilter,
        currentPage,
        dsSnackbarType,
        loading,
        listKey,
        filteredTodos,
        previousFilteredTodos,
      ];

  TodoState copyWith({
    List<TodoModel>? newTodos,
    TodoForm? newTodoForm,
    TodoFilter? newTodofilter,
    int? newCurrentPage,
    DsSnackbarType? dsSnackbarType,
    bool loading = false,
    List<TodoModel>? newPreviousFilteredTodos,
    List<TodoModel>? newFilteredTodos,
  }) {
    return TodoState(
      todos: newTodos ?? todos,
      todoForm: newTodoForm ?? todoForm,
      todoFilter: newTodofilter ?? todoFilter,
      currentPage: newCurrentPage ?? currentPage,
      dsSnackbarType: dsSnackbarType,
      loading: loading,
      listKey: listKey,
      previousFilteredTodos: newPreviousFilteredTodos ?? previousFilteredTodos,
      filteredTodos: newFilteredTodos ?? filteredTodos,
    );
  }
}
