import 'package:spark_up/network/httpprotocol.dart';

enum PostPath implements HttpPath{
  create(path: "post/create"),
  view(path: "post/view/%0");

  @override
  String get getPath => path;

  final String path;
  const PostPath({
    required this.path,
  });
}