import 'package:spark_up/network/httpprotocol.dart';

enum ChatPath implements HttpPath {
  message(path: "chat/messages"),
  rooms(path: "chat/rooms/%0"),
  roomUsers(path: "room_users/%0");

  @override
  String get getPath => path;

  final String path;
  const ChatPath({
    required this.path,
  });
}
