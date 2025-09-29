import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/networks/api_services.dart';
import '../models/movie_model.dart';
import 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final ApiServices apiServices;
  final String username; // user-specific

  MovieCubit(this.apiServices, this.username) : super(const MovieState());

  Future<void> init() async {
    await _loadFavorites();
    await fetchMovies();
  }

  Future<void> fetchMovies() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final popular = await apiServices.popularMovies();
      final topRated = await apiServices.topRatedMovies();
      final upcoming = await apiServices.upcomingMovies();

      emit(
        state.copyWith(
          popularMovies: popular,
          topRatedMovies: topRated,
          upcomingMovies: upcoming,
          filteredMovies: popular,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void searchMovies(String query) {
    final allMovies = [
      ...state.popularMovies,
      ...state.topRatedMovies,
      ...state.upcomingMovies,
    ];

    final filtered = query.isEmpty
        ? state.popularMovies
        : allMovies
              .where(
                (movie) =>
                    movie.title?.toLowerCase().contains(query.toLowerCase()) ??
                    false,
              )
              .toList();

    emit(state.copyWith(filteredMovies: filtered, searchQuery: query));
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList("favorite_movies_$username") ?? [];
    emit(state.copyWith(favoriteIds: favs));
  }

  Future<void> toggleFavorite(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = List<String>.from(state.favoriteIds);

    if (favs.contains(movie.id.toString())) {
      favs.remove(movie.id.toString());
    } else {
      favs.add(movie.id.toString());
    }

    await prefs.setStringList("favorite_movies_$username", favs);
    emit(state.copyWith(favoriteIds: favs));
  }

  bool isFavorite(Movie movie) {
    return state.favoriteIds.contains(movie.id.toString());
  }
}
