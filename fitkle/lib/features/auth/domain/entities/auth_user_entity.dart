import 'package:equatable/equatable.dart';

class AuthUserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;

  const AuthUserEntity({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, email, name, avatarUrl];
}
