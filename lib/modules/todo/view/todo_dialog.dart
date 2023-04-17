import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_todo/design_system/design_system.dart';
import 'package:premium_todo/modules/todo/todo.dart';

class TodoDialog extends StatefulWidget {
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
  State<TodoDialog> createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  late final TextEditingController _textEditingController;
  @override
  void initState() {
    _textEditingController =
        TextEditingController(text: widget.todo?.name ?? '');
    _textEditingController.addListener(() {
      if (!widget.isDelete) {
        widget.todoBloc.add(NameChanged(name: _textEditingController.text));
      }
    });
    super.initState();
  }

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
                style: TextStyle(color: DsColors.neutralWhite),
              ),
              IconButton(
                color: DsColors.neutralWhite,
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
          left: DsSpacing.xx,
          top: DsSpacing.xx,
          right: DsSpacing.xx,
        ),
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              DSTextField(
                controller: _textEditingController,
                hintText: widget.isDelete ? widget.todo?.name : 'Name',
                maxLines: 3,
                enabled: !widget.isDelete,
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        BlocBuilder<TodoBloc, TodoState>(
          buildWhen: (previous, current) =>
              previous.todoForm.name.value != current.todoForm.name.value,
          bloc: widget.todoBloc,
          builder: (context, state) {
            return Row(
              children: [
                if (widget.isDelete)
                  Expanded(
                    child: DsOutlinedButton(
                      child: const Text('Delete'),
                      onPressed: () {
                        widget.todoBloc.add(
                          DeleteTodo(id: widget.todo!.id),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  )
                else
                  Expanded(
                    child: DsOutlinedButton(
                      enabled: widget.todoBloc.state.todoForm.isValid,
                      child: const Text('Save'),
                      onPressed: () {
                        widget.todoBloc.add(CreateTodo());
                        Navigator.pop(context);
                      },
                    ),
                  )
              ],
            );
          },
        )
      ],
    );
  }
}
