import 'package:brew_coffee/domain/entities/coffee.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/domain/repositories/coffee_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogState extends Equatable {
  const CatalogState({
    this.loading = false,
    this.coffees = const [],
    this.featured = const [],
    this.popular = const [],
    this.seasonal,
    this.favoriteIds = const {},
    this.error,
  });

  final bool loading;
  final List<Coffee> coffees;
  final List<Coffee> featured;
  final List<Coffee> popular;
  final Coffee? seasonal;
  final Set<String> favoriteIds;
  final String? error;

  CatalogState copyWith({
    bool? loading,
    List<Coffee>? coffees,
    List<Coffee>? featured,
    List<Coffee>? popular,
    Coffee? seasonal,
    Set<String>? favoriteIds,
    String? error,
  }) {
    return CatalogState(
      loading: loading ?? this.loading,
      coffees: coffees ?? this.coffees,
      featured: featured ?? this.featured,
      popular: popular ?? this.popular,
      seasonal: seasonal ?? this.seasonal,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [loading, coffees, featured, popular, seasonal, favoriteIds, error];
}

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit(this._repository) : super(const CatalogState());

  final CoffeeRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final coffees = await _repository.getAllCoffees();
      final featured = await _repository.getFeatured();
      final popular = await _repository.getPopular();
      final seasonal = await _repository.getSeasonal();
      emit(state.copyWith(
        loading: false,
        coffees: coffees,
        featured: featured,
        popular: popular,
        seasonal: seasonal,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  List<Coffee> byCategory(CoffeeCategoryId category) {
    return state.coffees.where((c) => c.category == category).toList();
  }

  void toggleFavorite(String coffeeId) {
    final next = Set<String>.from(state.favoriteIds);
    if (next.contains(coffeeId)) {
      next.remove(coffeeId);
    } else {
      next.add(coffeeId);
    }
    emit(state.copyWith(favoriteIds: next));
  }
}
