import 'package:spark_up/network/httpprotocol.dart';

enum AuthPath implements HttpPath{
  register(path: "auth/register");

  @override
  String get getPath => path;

  final String path;
  const AuthPath({
    required this.path,
  });
}