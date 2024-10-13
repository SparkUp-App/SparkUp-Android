import 'package:spark_up/network/httpprotocol.dart';

enum CommentPath implements HttpPath{
  create(path: "comment/create"),
  delete(path: "comment/delete"),
  like(path: "comment/like"),
  list(path: "comment/list");

  @override
  String get getPath => path;

  final String path;
  const CommentPath({
    required this.path,
  });
}