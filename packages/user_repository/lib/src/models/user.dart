import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User(this.id, {this.email = ''});

  static const empty = User(Uuid.NAMESPACE_NIL);

  final String id;
  final String email;

  String get emailNormalised  => email.toUpperCase();

  @override
  List<Object> get props => [id, email];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
