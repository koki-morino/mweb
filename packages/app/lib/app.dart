import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:memkept/bloc/todo_bloc.dart';
import 'package:memkept/bloc/theme_mode_cubit.dart';
import 'package:memkept/bloc/websocket_bloc.dart';
import 'package:memkept/home.dart';
import 'package:memkept/theme.dart';
import 'package:memkept/protos/action.pb.dart' as protos;
import 'package:memkept/protos/message.pb.dart' as protos;
import 'package:memkept/protos/theme_mode.pb.dart' as protos;

final log = Logger("main");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeModeCubit>(
          create: (_) => ThemeModeCubit(),
        ),
        BlocProvider<TodoBloc>(
          create: (_) => TodoBloc()..add(const ListTodos({})),
        ),
        BlocProvider<WebsocketBloc>(
          create: (_) => WebsocketBloc()..add(const WebsocketInitialized()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ThemeModeCubit, ThemeMode>(
            listener: (context, state) async {
              final channel = context.read<WebsocketBloc>().channel;
              try {
                await channel?.ready;
                final message = protos.Message(
                  action: protos.Action.UpdateThemeMode,
                  themeMode:
                      protos.ThemeMode(isDarkMode: state == ThemeMode.dark),
                );
                channel?.sink.add(message.writeToBuffer());
              } catch (e) {
                log.severe(e);
              }
            },
          ),
          BlocListener<WebsocketBloc, WebsocketState>(
            listener: (context, state) async {
              if (context.read<WebsocketBloc>().state !=
                  const WebsocketAvailable()) {
                return;
              }

              final channel = context.read<WebsocketBloc>().channel;
              try {
                await channel?.ready;

                final themeModeReq =
                    protos.Message(action: protos.Action.GetThemeMode);
                channel?.sink.add(themeModeReq.writeToBuffer());

                final listTodosReq =
                    protos.Message(action: protos.Action.ListTodos);
                channel?.sink.add(listTodosReq.writeToBuffer());
              } catch (e) {
                log.severe(e);
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            final themeMode = context.watch<ThemeModeCubit>().state;

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'memkept',
              themeMode: themeMode,
              theme: lightTheme(),
              darkTheme: darkTheme(),
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}
