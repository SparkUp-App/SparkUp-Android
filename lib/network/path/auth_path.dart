import 'package:spark_up/network/httpprotocol.dart';

enum AuthPath implements HttpPath{
  register(path: "auth/register"),
  login(path: "auth/login");

  @override
  String get getPath => path;

  final String path;
  const AuthPath({
    required this.path,
  });
}