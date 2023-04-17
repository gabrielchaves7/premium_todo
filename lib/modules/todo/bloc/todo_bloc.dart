import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:premium_todo/bootstrap.dart';
import 'package:premium_todo/design_system/atoms/ds_snackbar.dart';
import 'package:premium_todo/design_system/molecules/ds_checkbox_tile.dart';
import 'package:premium_todo/modules/todo/todo.dart';
import 'package:uuid/uuid.dart';

part 'todo_event.dart';
part 'todo_state.dart';

enum TodoChangeType {
  add,
  delete,
  filterChange,
}

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({
    AddTodoUC? addTodoUC,
    GetTodosUC? getTodos,
    DeleteTodoUC? deleteTodoUC,
  }) : super(
          TodoState(
            todoForm: TodoForm(),
            todoFilter: TodoFilterAll(),
            listKey: GlobalKey<AnimatedListState>(),
          ),
        ) {
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
    emit(state.copyWith(loading: true));
    final newTodo =
        TodoModel(id: const Uuid().v4(), name: state.todoForm.name.value);
    final newTodos = [...state.todos, newTodo];
    final result = await _addTodoUC.call(newTodos);
    result.fold(
        (l) => emit(
              state.copyWith(dsSnackbarType: DsSnackbarType.todoCreateError),
            ), (r) {
      emit(
        state.copyWith(
          newTodos: newTodos,
          dsSnackbarType: DsSnackbarType.todoCreateSuccess,
          newFilteredTodos: state.todoFilter.filterList(newTodos),
        ),
      );
      _onTodosListChanged(
        index: newTodos.length - 1,
        todo: newTodo,
        type: TodoChangeType.add,
      );
    });
  }

  void _mapNameChangedEventToState(
    NameChanged event,
    Emitter<TodoState> emit,
  ) {
    final newTodoForm = TodoForm(name: NameInput.dirty(value: event.name));
    emit(state.copyWith(newTodoForm: newTodoForm));
  }

  Future<void> _mapGetTodosEventToState(
    GetTodos event,
    Emitter<TodoState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final result = await _getTodos.call();
    result.fold(
      (l) => emit(state.copyWith(dsSnackbarType: DsSnackbarType.todoGetError)),
      (r) => emit(state.copyWith(newTodos: r, newFilteredTodos: r)),
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
    emit(
      state.copyWith(
        newTodos: updatedTodos,
        newFilteredTodos: state.todoFilter.filterList(updatedTodos),
      ),
    );
  }

  void _mapChangeTodoFilterEventToState(
    ChangeTodoFilter event,
    Emitter<TodoState> emit,
  ) {
    final newFilteredTodos = event.todoFilter.filterList(state.todos);
    final previousFilteredTodos = state.todoFilter.filterList(state.todos);
    emit(
      state.copyWith(
        newTodofilter: event.todoFilter,
        newCurrentPage: event.newCurrentPage,
        newPreviousFilteredTodos: previousFilteredTodos,
        newFilteredTodos: newFilteredTodos,
      ),
    );
    _onTodosListChanged(
      type: TodoChangeType.filterChange,
    );
  }

  Future<void> _mapDeleteTodoEventToState(
    DeleteTodo event,
    Emitter<TodoState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final index = state.filteredTodos.indexWhere((e) => e.id == event.id);
    final removedTodo = state.filteredTodos[index];
    final newTodos = List<TodoModel>.from(
      state.todos
          .map((e) => TodoModel(id: e.id, name: e.name, status: e.status)),
    )..removeWhere((it) => it.id == event.id);

    final result = await _deleteTodoUC.call(newTodos);

    result.fold(
      (l) =>
          emit(state.copyWith(dsSnackbarType: DsSnackbarType.todoDeleteError)),
      (r) {
        emit(
          state.copyWith(
            newTodos: newTodos,
            dsSnackbarType: DsSnackbarType.todoDeleteSuccess,
            newFilteredTodos: state.todoFilter.filterList(newTodos),
          ),
        );

        _onTodosListChanged(
          index: index,
          todo: removedTodo,
          type: TodoChangeType.delete,
        );
      },
    );
  }

  void _onTodosListChanged({
    required TodoChangeType type,
    TodoModel? todo,
    int? index,
  }) {
    if (type == TodoChangeType.add) {
      _animateInsertTodo(index: index!);
    } else if (type == TodoChangeType.delete) {
      _animateRemovedTodo(index: index!, item: todo!);
    } else if (type == TodoChangeType.filterChange) {
      final removedTodos = state.previousFilteredTodos.toList()
        ..removeWhere(state.filteredTodos.contains);
      final addedTodos = state.filteredTodos.toList()
        ..removeWhere(state.previousFilteredTodos.contains);

      for (final item in removedTodos) {
        _animateRemovedTodo(
          index: state.previousFilteredTodos.indexOf(item),
          item: item,
        );
      }

      for (final item in addedTodos) {
        _animateInsertTodo(index: state.filteredTodos.indexOf(item));
      }
    }
  }

  void _animateRemovedTodo({required int index, required TodoModel item}) {
    state.listKey.currentState?.removeItem(
      index,
      (context, animation) => DsCheckboxTile(
        title: item.name,
        value: item.status == TodoStatus.done,
      ),
      duration: const Duration(milliseconds: 500),
    );
  }

  void _animateInsertTodo({required int index}) {
    state.listKey.currentState?.insertItem(
      index,
      duration: const Duration(milliseconds: 500),
    );
  }
}
