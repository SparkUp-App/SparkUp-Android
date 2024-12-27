import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:spark_up/chat/data/approved_message.dart';
import 'package:spark_up/chat/data/chat_message.dart';
import 'package:spark_up/chat/data/rejected_message.dart';

// Define callback types
typedef MessageCallback = void Function(ChatMessage message);
typedef ApprovedCallback = void Function(ApprovedMessage message);
typedef RejectedCallback = void Function(RejectedMessage message);
typedef StatusCallback = void Function(SocketStatus status, String? message);

class SocketService {
  // Setting Connect URL
  static const String baseUrl = "https://sparkup-9db24d093e0f.herokuapp.com";

  // Singleton pattern (Differ from normal setting just for restrict factory or other declare)
  static SocketService manager = SocketService();

  IO.Socket? socket;
  int? _userId;

  // Callbacks
  MessageCallback? onNewMessage;
  ApprovedCallback? onNewApprovedMessage;
  RejectedCallback? onNewRejectedMessage;
  StatusCallback? onStatusChange;

  bool get isConnected => socket?.connected ?? false;
  int? get currentUserId => _userId;

  void initSocket({
    required int userId,
    MessageCallback? onMessage,
    StatusCallback? onStatus,
    ApprovedCallback? onApprovedMessage,
    RejectedCallback? onRejectedMessage,
  }) {
    _userId = userId;
    onNewMessage = onMessage;
    onStatusChange = onStatus;
    onNewApprovedMessage = onApprovedMessage;
    onNewRejectedMessage = onRejectedMessage;

    debugPrint("Build Socket Connect");
    // Initialize socket with configuration
    socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'user_id': userId.toString()},
      'reconnection': true, // Enable reconnection
      'reconnectionDelay': 1000, // Delay before attempting to reconnect
      'reconnectionDelayMax':
          5000, // Maximum delay between reconnection attempts
      'forceNew': true,
    });

    _setupEventHandlers();
    socket!.connect();
  }

  void _setupEventHandlers() {
    socket!
      ..onConnect((_) {
        debugPrint('Socket connected');
        onStatusChange?.call(SocketStatus.connected, 'Connected to server');
      })
      ..onDisconnect((_) {
        debugPrint('Socket disconnected');
        onStatusChange?.call(
            SocketStatus.disconnected, 'Disconnected from server');
      })
      ..onError((error) {
        debugPrint('Socket error: $error');
        onStatusChange?.call(SocketStatus.error, error.toString());
      })
      ..onConnectError((error) {
        debugPrint('Connection error: $error');
        onStatusChange?.call(SocketStatus.error, 'Connection failed: $error');
      })
      ..on('new_message', _handleNewMessage)
      ..on('application_approved', _handleNewApproved)
      ..on('application_rejected', _handleNewRejected);
  }

  void _handleNewMessage(dynamic data) {
    try {
      final message = ChatMessage.initfromData(data);
      debugPrint('New message received: ${message.content}');
      onNewMessage?.call(message);
    } catch (e) {
      debugPrint('Error parsing message: $e');
      onStatusChange?.call(SocketStatus.error, 'Error parsing message: $e');
    }
  }

  void _handleNewApproved(dynamic data) {
    try {
      final message = ApprovedMessage.initfromData(data);
      debugPrint('New message received: ${message.message}');
      onNewApprovedMessage?.call(message);
    } catch (e) {
      debugPrint('Error parsing message: $e');
      onStatusChange?.call(SocketStatus.error, 'Error parsing message: $e');
    }
  }

  void _handleNewRejected(dynamic data) {
    try {
      final message = RejectedMessage.initfromData(data);
      debugPrint('New message received: ${message.message}');
      onNewRejectedMessage?.call(message);
    } catch (e) {
      debugPrint('Error parsing message: $e');
      onStatusChange?.call(SocketStatus.error, 'Error parsing message: $e');
    }
  }

  Future<bool> sendMessage({
    required int postId,
    required String content,
    int timeoutSeconds = 10,
  }) async {
    if (!isConnected || _userId == null) {
      throw SocketException('Socket is not connected');
    }

    Completer<bool> sendCompleter = Completer();
    Timer? timeoutTimer;

    try {
      socket!.emit('send_message', {
        'post_id': postId,
        'sender_id': _userId,
        'content': content,
      });

      socket!.on('new_message', (data) {
        final message = ChatMessage.initfromData(data);
        if (message.content == content) {
          timeoutTimer?.cancel();
          if (!sendCompleter.isCompleted) {
            sendCompleter.complete(true);
          }
        }
      });

      timeoutTimer = Timer(Duration(seconds: timeoutSeconds), () {
        if (!sendCompleter.isCompleted) {
          sendCompleter.complete(false);
          throw SocketException("Timeout");
        }
      });
      return await sendCompleter.future;
    } catch (e) {
      debugPrint('Error sending message: $e');
      if (!sendCompleter.isCompleted) {
        sendCompleter.complete(false);
      }
      throw SocketException('Failed to send message: $e');
    }
  }

  void disconnect() {
    if (socket != null) {
      socket!
        ..off("connect")
        ..off("disconnect")
        ..off("error")
        ..off("connect_error")
        ..off("new_message");
    }
    socket?.disconnect();
    socket?.close();
    socket?.dispose();
    socket = null;
    _userId = null;
    onNewMessage = null;
    onStatusChange = null;
  }
}

class SocketException implements Exception {
  final String message;
  SocketException(this.message);

  @override
  String toString() => 'SocketException: $message';
}

// Define event types
enum SocketStatus { connected, disconnected, error }
