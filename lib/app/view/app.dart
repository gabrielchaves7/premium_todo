import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_todo/design_system/design_system.dart';
import 'package:premium_todo/modules/todo/todo.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoBloc(),
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: DsColors.brandColorPrimary),
          colorScheme: ColorScheme.fromSwatch(
            accentColor: DsColors.brandColorPrimaryLight,
          ),
        ),
        home: const TodoPage(),
      ),
    );
  }
}
