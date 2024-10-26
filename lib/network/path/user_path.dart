import 'package:spark_up/network/httpprotocol.dart';

enum UserPath implements HttpPath{
  applied(path: "user/applied/%0"),
  bookmarks(path: "user/bookmarks/%0"),
  view(path: "user/view/%0");

  @override
  String get getPath => path;

  final String path;
  const UserPath({
    required this.path,
  });
}