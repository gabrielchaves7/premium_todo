import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:premium_todo/bootstrap.dart';
import 'package:premium_todo/design_system/atoms/ds_snackbar.dart';
import 'package:premium_todo/todo/bloc/todo_filters.dart';
import 'package:premium_todo/todo/forms/todo_form.dart';
import 'package:premium_todo/todo/model/todo_model.dart';
import 'package:premium_todo/todo/usecases/add_todo_usecase.dart';
import 'package:premium_todo/todo/usecases/delete_todo_usecase.dart';
import 'package:premium_todo/todo/usecases/get_todos_usecase.dart';
import 'package:uuid/uuid.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({
    AddTodoUC? addTodoUC,
    GetTodosUC? getTodos,
    DeleteTodoUC? deleteTodoUC,
  }) : super(TodoState(todoForm: TodoForm(), todoFilter: TodoFilterAll())) {
    _addTodoUC = addTodoUC ?? getIt.get<AddTodoUC>();
    _getTodos = getTodos ?? getIt.get<GetTodosUC>();
    _deleteTodoUC = deleteTodoUC ?? getIt.get<DeleteTodoUC>();

    on<CreateTodo>(_mapCreateTodoEventToState);
    on<NameChanged>(_mapNameChangedEventToState);
    on<GetTodos>(_mapGetTodosEventToState);
    on<UpdateTodoStatus>(_mapUpdateTodoStatusEventToState);
    on<ChangeTodoFilter>(_mapChangeTodoFilterEventToState);
    on<DeleteTodo>(_mapDeleteTodoEventToState);
  }

  late final AddTodoUC _addTodoUC;
  late final GetTodosUC _getTodos;
  late final DeleteTodoUC _deleteTodoUC;

  Future<void> _mapCreateTodoEventToState(
    CreateTodo event,
    Emitter<TodoState> emit,
  ) async {
    final newTodo =
        TodoModel(id: const Uuid().v4(), name: state.todoForm.name.value);
    final newTodos = [...state.todos, newTodo];
    final result = await _addTodoUC.call(newTodos);
    result.fold(
      (l) =>
          emit(state.copyWith(dsSnackbarType: DsSnackbarType.todoCreateError)),
      (r) => emit(
        state.copyWith(
          newTodos: newTodos,
          dsSnackbarType: DsSnackbarType.todoCreateSuccess,
        ),
      ),
    );
  }

  void _mapNameChangedEventToState(
    NameChanged event,
    Emitter<TodoState> emit,
  ) {
    final newTodoForm = state.todoForm
      ..name = NameInput.dirty(value: event.name);
    emit(state.copyWith(newTodoForm: newTodoForm));
  }

  Future<void> _mapGetTodosEventToState(
    GetTodos event,
    Emitter<TodoState> emit,
  ) async {
    final result = await _getTodos.call();
    result.fold(
      (l) => emit(state.copyWith(dsSnackbarType: DsSnackbarType.todoGetError)),
      (r) => emit(state.copyWith(newTodos: r)),
    );
  }

  Future<void> _mapUpdateTodoStatusEventToState(
    UpdateTodoStatus event,
    Emitter<TodoState> emit,
  ) async {
    final updatedTodos = List<TodoModel>.from(
      state.todos
          .map((e) => TodoModel(id: e.id, name: e.name, status: e.status)),
    );
    updatedTodos.firstWhere((e) => e.id == event.id).status = event.newStatus;
    emit(state.copyWith(newTodos: updatedTodos));
  }

  void _mapChangeTodoFilterEventToState(
    ChangeTodoFilter event,
    Emitter<TodoState> emit,
  ) {
    emit(
      state.copyWith(
        newTodofilter: event.todoFilter,
        newCurrentPage: event.newCurrentPage,
      ),
    );
  }

  Future<void> _mapDeleteTodoEventToState(
    DeleteTodo event,
    Emitter<TodoState> emit,
  ) async {
    final newTodos = List<TodoModel>.from(
      state.todos
          .map((e) => TodoModel(id: e.id, name: e.name, status: e.status)),
    )..removeWhere((e) => e.id == event.id);

    final result = await _deleteTodoUC.call(newTodos);

    result.fold(
      (l) =>
          emit(state.copyWith(dsSnackbarType: DsSnackbarType.todoDeleteError)),
      (r) => emit(
        state.copyWith(
          newTodos: newTodos,
          dsSnackbarType: DsSnackbarType.todoDeleteSuccess,
        ),
      ),
    );
  }
}
