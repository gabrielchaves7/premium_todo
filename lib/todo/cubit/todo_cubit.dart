import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:premium_todo/bootstrap.dart';
import 'package:premium_todo/todo/forms/todo_form.dart';
import 'package:premium_todo/todo/model/todo_model.dart';
import 'package:premium_todo/todo/usecases/create_task_usecase.dart';

part 'todo_state.dart';
part 'todo_event.dart';

class TodoCubit extends Bloc<TodoEvent, TodoState> {
  TodoCubit({CreateTodoUC? createTodoUC})
      : super(TodoState(todoForm: TodoForm())) {
    _createTodoUC = createTodoUC ?? getIt.get<CreateTodoUC>();

    on<CreateTodo>(_mapCreateTodoEventToState);
    on<NameChanged>(_mapNameChangedEventToState);
  }

  late final CreateTodoUC _createTodoUC;

  Future<void> _mapCreateTodoEventToState(
    CreateTodo event,
    Emitter<TodoState> emit,
  ) async {
    final newTodo =
        TodoModel(state.todoForm.name.value, state.todoForm.name.value);
    final result = await _createTodoUC.call(newTodo);
    result.fold(
      (l) => print(l),
      (r) => emit(state.copyWith(newTodos: [...state.todos, newTodo])),
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
}
