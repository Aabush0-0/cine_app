import '../models/movie_model.dart';

class MovieState {
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> upcomingMovies;
  final List<Movie> filteredMovies;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  const MovieState({
    this.popularMovies = const [],
    this.topRatedMovies = const [],
    this.upcomingMovies = const [],
    this.filteredMovies = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
  });

  MovieState copyWith({
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
    List<Movie>? upcomingMovies,
    List<Movie>? filteredMovies,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MovieState(
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
      filteredMovies: filteredMovies ?? this.filteredMovies,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
