import 'package:spark_up/network/httpprotocol.dart';

enum PostPath implements HttpPath{
  bookmark(path: "post/bookmark"),
  like(path: "post/like"),
  create(path: "post/create"),
  list(path: "post/list/%0"), //%0 => UserId
  view(path: "post/view");

  @override
  String get getPath => path;

  final String path;
  const PostPath({
    required this.path,
  });
}