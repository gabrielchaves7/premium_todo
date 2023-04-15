import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:premium_todo/bootstrap.dart';
import 'package:premium_todo/todo/forms/todo_form.dart';
import 'package:premium_todo/todo/model/todo_model.dart';
import 'package:premium_todo/todo/usecases/add_todo_usecase.dart';
import 'package:premium_todo/todo/usecases/get_todos_usecase.dart';

part 'todo_state.dart';
part 'todo_event.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({AddTodoUC? addTodoUC, GetTodosUC? getTodos})
      : super(TodoState(todoForm: TodoForm())) {
    _addTodoUC = addTodoUC ?? getIt.get<AddTodoUC>();
    _getTodos = getTodos ?? getIt.get<GetTodosUC>();

    on<CreateTodo>(_mapCreateTodoEventToState);
    on<NameChanged>(_mapNameChangedEventToState);
    on<GetTodos>(_mapGetTodosEventToState);
    on<UpdateTodoStatus>(_mapUpdateTodoStatusEventToState);
  }

  late final AddTodoUC _addTodoUC;
  late final GetTodosUC _getTodos;

  Future<void> _mapCreateTodoEventToState(
    CreateTodo event,
    Emitter<TodoState> emit,
  ) async {
    final newTodo = TodoModel(name: state.todoForm.name.value);
    final newTodos = [...state.todos, newTodo];
    final result = await _addTodoUC.call(newTodos);
    result.fold(
      (l) => print(l),
      (r) => emit(state.copyWith(newTodos: newTodos)),
    );
  }

  Future<void> _mapNameChangedEventToState(
    NameChanged event,
    Emitter<TodoState> emit,
  ) async {
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
      (l) => print(l),
      (r) => emit(state.copyWith(newTodos: r)),
    );
  }

  Future<void> _mapUpdateTodoStatusEventToState(
    UpdateTodoStatus event,
    Emitter<TodoState> emit,
  ) async {
    final updatedTodos = state.todos;
    final index =
        state.todos.indexWhere((element) => element.name == event.name);
    updatedTodos[index].status = event.newStatus;
    emit(state.copyWith(newTodos: updatedTodos));
  }
}
