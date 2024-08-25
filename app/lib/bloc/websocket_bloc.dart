import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:memkept/protos/action.pb.dart';
import 'package:memkept/protos/message.pb.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'websocket_event.dart';
part 'websocket_state.dart';

final log = Logger("main");

// TODO: Use environment variable.
final uri = Uri.parse('ws://localhost:8000/ws');

class WebsocketBloc extends Bloc<WebsocketEvent, WebsocketState> {
  Timer? timer;
  WebSocketChannel? channel;

  WebsocketBloc() : super(const WebsocketConnecting()) {
    on<WebsocketInitialized>(_onInitialized);
    on<WebsocketConnected>(_onConnected);
    on<WebsocketDisconnected>(_onDisconnected);
  }

  @override
  Future<void> close() {
    timer?.cancel();
    channel?.sink.close(WebSocketStatus.normalClosure);
    return super.close();
  }

  void _onInitialized(
      WebsocketInitialized event, Emitter<WebsocketState> emit) async {
    log.fine("Connecting to websocket...");
    channel?.sink.close(WebSocketStatus.normalClosure);
    channel = WebSocketChannel.connect(uri);

    try {
      await channel?.ready;
      add(const WebsocketConnected());
    } catch (e) {
      log.severe(e);
      add(const WebsocketDisconnected());
    }
  }

  void _onConnected(WebsocketConnected event, Emitter<WebsocketState> emit) {
    emit(const WebsocketAvailable());

    channel?.stream.listen(
      (message) {
        final req = Message.fromBuffer(message);
        _handleRequest(req);
      },
      onDone: () {
        log.fine("Websocket connection closed.");
        timer?.cancel();
        add(const WebsocketDisconnected());
      },
      onError: (error) {
        log.severe("Error in websocket connection: $error");
        timer?.cancel();
        add(const WebsocketDisconnected());
      },
    );

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 30), (_) {
      log.fine("Pinging...");
      final message = Message(action: Action.Ping);
      channel?.sink.add(message.writeToBuffer());
    });
  }

  void _onDisconnected(
      WebsocketDisconnected event, Emitter<WebsocketState> emit) async {
    emit(const WebsocketConnecting());

    log.fine("Disconnected from websocket.");
    log.fine('Retrying in 5 seconds.');

    await Future.delayed(const Duration(seconds: 5));

    log.fine("Connecting to websocket...");
    channel?.sink.close(WebSocketStatus.normalClosure);
    channel = WebSocketChannel.connect(uri);

    try {
      await channel?.ready;
      add(const WebsocketConnected());
    } catch (e) {
      log.severe(e);
      add(const WebsocketDisconnected());
    }
  }

  void _handleRequest(Message req) {
    log.fine("Action: ${req.action}");
  }
}
