import 'package:spark_up/network/httpprotocol.dart';

enum ApplicantPath implements HttpPath{
  create(path: "applicant/create"),
  list(path: "applicant/list/%0"),
  delete(path: "applicant/retrieve"),
  review(path: "applicant/review");

  @override
  String get getPath => path;

  final String path;
  const ApplicantPath({
    required this.path,
  });
}