import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:premium_todo/modules/shared_preferences/shared_preferences.dart';
import 'package:premium_todo/modules/todo/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> setup() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt
    ..registerSingleton<SharedPreferences>(sharedPreferences)
    //datasources

    ..registerLazySingleton<DataSource>(SharedPreferencesDataSource.new)
    //repository
    ..registerLazySingleton<TodoRepository>(TodoRepository.new)
    ..registerLazySingleton<AddTodoUC>(AddTodoUC.new)
    ..registerLazySingleton<GetTodosUC>(GetTodosUC.new)
    ..registerLazySingleton<DeleteTodoUC>(DeleteTodoUC.new);
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();
  await setup();
  await runZonedGuarded(
    () async => runApp(await builder()),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
