import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/api_response_model.dart';
import 'package:app/features/auth/data/source/auth_cache.dart';
import 'package:app/features/auth/logic/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

@lazySingleton
class SocketIoService {
  io.Socket? _socket;
  bool _isConnected = false;
  final List<void Function(io.Socket)> _pendingListeners = [];

  void connect() async {
    // if we already created & connected the socket, skip
    if (_isConnected) {
      debugPrint('🔌 Socket is already connected');
      return;
    }

    await locator<AuthCubit>().refreshToken();

    final url = dotenv.env['SOCKET_IO_URL'];
    final token = locator<AuthCache>().accessToken;

    _socket = io.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'token': '$token'},
    });

    _socket!
      ..on('connect', (_) {
        _isConnected = true;
        debugPrint('🔌 Socket connected!');
        // Apply any queued listeners
        for (final listener in _pendingListeners) {
          listener(_socket!);
        }
        _pendingListeners.clear();
      })
      ..on('disconnect', (_) {
        _isConnected = false;
        debugPrint('⚡️ Socket disconnected');
      })
      ..on('connect_error', (err) {
        debugPrint('❌ Connection error: $err');
      });

    _socket!.connect();
  }

  void disconnect() {
    if (_isConnected) _socket!.disconnect();
  }

  void onData(String event, Function(DataApiResponse data) callback) {
    void listener(io.Socket socket) {
      debugPrint('🔌 [Queued] Listening for event: $event');
      socket.on(event, (data) {
        debugPrint(
          '📥 Received data for event: $event with data $data',
        );
        if (data is Map<String, dynamic>) {
          final response = DataApiResponse.fromJson(data);
          callback(response);
        } else {
          callback(data);
        }
      });
    }

    if (_isConnected && _socket != null) {
      listener(_socket!);
    } else {
      debugPrint(
        '⚠️ Socket not connected, queueing listener for $event',
      );
      _pendingListeners.add(listener);
    }
  }

  void onMultiData(
    String event,
    Function(MultiDataApiResponse data) callback,
  ) async {
    _socket!.on(event, (data) {
      if (data is Map<String, dynamic>) {
        final response = MultiDataApiResponse.fromJson(data);
        callback(response);
      } else {
        callback(data);
      }
    });
  }

  void off(String event) {
    debugPrint('🔌 Stopping listening for event: $event');
    if (_isConnected) _socket!.off(event);
  }
}
