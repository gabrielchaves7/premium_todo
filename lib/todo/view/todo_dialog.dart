import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_todo/design_system/atoms/spacing.dart';
import 'package:premium_todo/design_system/molecules/ds_button.dart';
import 'package:premium_todo/design_system/molecules/ds_text_form_field.dart';
import 'package:premium_todo/todo/bloc/todo_bloc.dart';
import 'package:premium_todo/todo/model/todo_model.dart';

class TodoDialog extends StatelessWidget {
  const TodoDialog({
    required this.todoBloc,
    super.key,
    this.isDelete = false,
    this.todo,
  }) : assert(
          (isDelete && todo != null) || (!isDelete && todo == null),
          'if isDelete is true, todo cant be null',
        );

  final TodoBloc todoBloc;
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
                    : (value) => todoBloc.add(NameChanged(name: value)),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            if (isDelete)
              Expanded(
                child: DsOutlinedButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    todoBloc.add(DeleteTodo(name: todo!.name));
                    Navigator.pop(context);
                  },
                ),
              )
            else
              Expanded(
                child: DsOutlinedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    todoBloc.add(CreateTodo());
                    Navigator.pop(context);
                  },
                ),
              )
          ],
        )
      ],
    );
  }
}
