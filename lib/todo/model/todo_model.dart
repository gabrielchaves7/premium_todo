// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

enum TodoStatus {
  pending,
  done,
}

@JsonSerializable()
class TodoModel extends Equatable {
  TodoModel(
      {required this.id, required this.name, this.status = TodoStatus.pending});

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);
  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  @override
  List<Object?> get props => [name, status];

  String id;
  String name;
  TodoStatus status;

  static List<String> toStringList(List<TodoModel> todos) {
    return todos.map((e) => jsonEncode(e.toJson())).toList();
  }

  static List<TodoModel> fromStringList(List<String> todos) {
    return todos
        .map((e) => TodoModel.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }
}
