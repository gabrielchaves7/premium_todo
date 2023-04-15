// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoModel _$TodoModelFromJson(Map<String, dynamic> json) => TodoModel(
      name: json['name'] as String,
      status: $enumDecodeNullable(_$TodoStatusEnumMap, json['status']) ??
          TodoStatus.pending,
    );

Map<String, dynamic> _$TodoModelToJson(TodoModel instance) => <String, dynamic>{
      'name': instance.name,
      'status': _$TodoStatusEnumMap[instance.status]!,
    };

const _$TodoStatusEnumMap = {
  TodoStatus.pending: 'pending',
  TodoStatus.done: 'done',
};
