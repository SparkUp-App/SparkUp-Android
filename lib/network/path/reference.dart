import 'package:spark_up/network/httpprotocol.dart';

enum ReferencePath implements HttpPath {
  create(path: "reference/create"),
  myList(path: "reference/list/%0"),
  referenceableList(path: "reference/list_referenceable/%0");

  @override
  String get getPath => path;

  final String path;
  const ReferencePath({
    required this.path,
  });
}
