import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/networks/api_services.dart';
import 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final ApiServices apiServices;

  MovieCubit(this.apiServices) : super(const MovieState());

  Future<void> fetchMovies() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final popular = await apiServices.popularMovies();
      final topRated = await apiServices.topRatedMovies();
      final upcoming = await apiServices.upcomingMovies();

      emit(
        state.copyWith(
          popularMovies: popular,
          filteredMovies: popular,
          topRatedMovies: topRated,
          upcomingMovies: upcoming,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void searchMovies(String query) {
    if (query.isEmpty) {
      emit(
        state.copyWith(filteredMovies: state.popularMovies, searchQuery: ''),
      );
      return;
    }

    final allMovies = [
      ...state.popularMovies,
      ...state.topRatedMovies,
      ...state.upcomingMovies,
    ];

    final filtered = allMovies
        .where(
          (movie) =>
              movie.title?.toLowerCase().contains(query.toLowerCase()) ?? false,
        )
        .toList();

    emit(state.copyWith(filteredMovies: filtered, searchQuery: query));
  }
}
