import 'package:json_annotation/json_annotation.dart';

part 'alumni.g.dart';

@JsonSerializable()
class AlumniRequest {
  final String id;
  final String alumniId;
  final String alumniUsername;
  final String alumniEmail;
  final String professorId;
  final String professorEmail;
  final String status;
  final String createdAt;

  AlumniRequest({
    required this.id,
    required this.alumniId,
    required this.alumniUsername,
    required this.alumniEmail,
    required this.professorId,
    required this.professorEmail,
    required this.status,
    required this.createdAt,
  });

  factory AlumniRequest.fromJson(Map<String, dynamic> json) => _$AlumniRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AlumniRequestToJson(this);
}