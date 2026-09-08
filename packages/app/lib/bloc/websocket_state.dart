part of 'websocket_bloc.dart';

sealed class WebsocketState {
  const WebsocketState();
}

final class WebsocketAvailable extends WebsocketState {
  const WebsocketAvailable();

  @override
  String toString() => 'WebsocketAvailable';
}

final class WebsocketConnecting extends WebsocketState {
  const WebsocketConnecting();

  @override
  String toString() => 'WebsocketConnecting';
}
