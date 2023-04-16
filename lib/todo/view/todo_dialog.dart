import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_todo/design_system/atoms/spacing.dart';
import 'package:premium_todo/design_system/molecules/ds_text_form_field.dart';
import 'package:premium_todo/todo/bloc/todo_bloc.dart';
import 'package:premium_todo/todo/model/todo_model.dart';

class TodoDialog extends StatelessWidget {
  const TodoDialog({super.key, this.isDelete = false, this.todo});

  final TodoModel? todo;
  final bool isDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      title: ColoredBox(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(left: DsSpacing.xx),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Todo',
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(
            left: DsSpacing.xx, top: DsSpacing.xx, right: DsSpacing.xx),
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              DSTextField(
                hintText: isDelete ? todo?.name : 'Name',
                maxLines: 3,
                enabled: !isDelete,
                onChanged: isDelete
                    ? null
                    : (value) =>
                        context.read<TodoBloc>()..add(NameChanged(name: value)),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        if (isDelete)
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              context.read<TodoBloc>().add(DeleteTodo(name: ''));
            },
          )
        else
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              context.read<TodoBloc>().add(CreateTodo());
            },
          )
      ],
    );
  }
}
