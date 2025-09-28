import 'package:cinema_app/core/networks/api_urls.dart';
import 'package:cinema_app/models/movie_model.dart';
import 'package:dio/dio.dart';

class ApiServices {
  final Dio _dio = Dio();

  ApiServices() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = ApiUrls.token;
          options.headers['accept'] = 'application/json';
          return handler.next(options); // continue
        },
        onResponse: (response, handler) {
          return handler.next(response); // continue
        },
        onError: (DioError e, handler) {
          print('Dio error: ${e.message}');
          return handler.next(e); // continue
        },
      ),
    );
  }

  Future<List<Movie>> popularMovies() async {
    return _fetchMovies('https://api.themoviedb.org/3/movie/popular');
  }

  Future<List<Movie>> topRatedMovies() async {
    return _fetchMovies(
      'https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1',
    );
  }

  Future<List<Movie>> upcomingMovies() async {
    return _fetchMovies(
      'https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1',
    );
  }

  Future<List<Movie>> similarMovies(int movieId) async {
    return _fetchMovies(
      'https://api.themoviedb.org/3/movie/$movieId/similar?language=en-US&page=1',
    );
  }

  Future<List<Movie>> _fetchMovies(String url) async {
    try {
      final response = await _dio.get(url);
      final results = response.data['results'] as List<dynamic>;
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching movies: $e');
      return [];
    }
  }
}
