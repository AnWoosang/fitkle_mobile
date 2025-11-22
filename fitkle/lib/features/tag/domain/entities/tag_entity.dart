import 'package:equatable/equatable.dart';

class TagEntity extends Equatable {
  final String id;
  final String name;
  final String categoryGroup;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TagEntity({
    required this.id,
    required this.name,
    required this.categoryGroup,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        categoryGroup,
        isActive,
        createdAt,
        updatedAt,
      ];
}
