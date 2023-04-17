// ignore_for_file: strict_raw_type

import 'package:formz/formz.dart';

enum NameInputError { empty }

class NameInput extends FormzInput<String, NameInputError> {
  const NameInput.pure() : super.pure('');

  const NameInput.dirty({String value = ''}) : super.dirty(value);

  @override
  NameInputError? validator(String value) {
    return value.isEmpty ? NameInputError.empty : null;
  }
}

class TodoForm with FormzMixin {
  TodoForm({
    this.name = const NameInput.pure(),
  });

  NameInput name;

  @override
  List<FormzInput> get inputs => [name];
}
