import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/api_response_model.dart';
import 'package:app/features/auth/data/source/auth_cache.dart';
import 'package:app/features/auth/logic/auth_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

@lazySingleton
class SocketIoService {
  late io.Socket _socket;

  void connect() async {
    if (_socket.connected) return;

    await locator<AuthCubit>().refreshToken();

    final url = dotenv.env['SOCKET_IO_URL'];
    final token = locator<AuthCache>().accessToken;

    _socket = io.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'token': token},
    });

    _connect();
  }

  void _connect() => _socket.connect();

  void disconnect() => _socket.connected ? _socket.disconnect() : {};

  void onData(String event, Function(DataApiResponse data) callback) {
    connect();

    _socket.on(event, (data) {
      if (data is Map<String, dynamic>) {
        final response = DataApiResponse.fromJson(data);
        callback(response);
      } else {
        callback(data);
      }
    });
  }

  void onMultiData(
    String event,
    Function(MultiDataApiResponse data) callback,
  ) {
    connect();

    _socket.on(event, (data) {
      if (data is Map<String, dynamic>) {
        final response = MultiDataApiResponse.fromJson(data);
        callback(response);
      } else {
        callback(data);
      }
    });
  }

  void off(String event) =>
      _socket.connected ? _socket.off(event) : {};
}
