import 'package:spark_up/network/httpprotocol.dart';

enum ProfilePath implements HttpPath{
  update(path: "profile/update/%0"),
  view(path: "profile/view/%0");

  @override
  String get getPath => path;

  final String path;
  const ProfilePath({
    required this.path,
  });
}