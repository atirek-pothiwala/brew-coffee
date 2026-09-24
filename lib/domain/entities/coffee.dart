import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:equatable/equatable.dart';

class Coffee extends Equatable {
  const Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.basePrice,
    required this.imageGradientStart,
    required this.imageGradientEnd,
    this.isFeatured = false,
    this.isPopular = false,
    this.isSeasonal = false,
  });

  final String id;
  final String name;
  final String description;
  final CoffeeCategoryId category;
  final int basePrice;
  final int imageGradientStart;
  final int imageGradientEnd;
  final bool isFeatured;
  final bool isPopular;
  final bool isSeasonal;

  @override
  List<Object?> get props => [id];
}
