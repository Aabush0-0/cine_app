import 'package:flutter/material.dart';

import '../core/networks/api_services.dart';
import '../models/movie_model.dart';
import '../widgets/movie_section.dart';

class MovieDetails extends StatefulWidget {
  final Movie iMovie;

  const MovieDetails({super.key, required this.iMovie});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  final ApiServices _apiServices = ApiServices();

  final ValueNotifier<List<Movie>> _similarMovies = ValueNotifier<List<Movie>>(
    [],
  );
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _fetchSimilarMovies();
  }

  Future<void> _fetchSimilarMovies() async {
    try {
      final movies = await _apiServices.similarMovies(widget.iMovie.id);
      _similarMovies.value = movies;
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _similarMovies.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.iMovie.title ?? "Movie Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Backdrop
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: widget.iMovie.backdropPath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${widget.iMovie.backdropPath}',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.movie, size: 50),
                    ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              widget.iMovie.title ?? 'No Title',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Overview
            Text(widget.iMovie.overview ?? "No Overview"),

            const SizedBox(height: 20),

            // Release date
            Text(
              "Release Date: ${widget.iMovie.releaseDate ?? "Unknown"}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 30),

            // Similar movies
            ValueListenableBuilder<bool>(
              valueListenable: _isLoading,
              builder: (context, loading, _) {
                if (loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ValueListenableBuilder<List<Movie>>(
                  valueListenable: _similarMovies,
                  builder: (context, movies, _) {
                    if (movies.isEmpty) {
                      return const Text("No similar movies found.");
                    }
                    return MovieSection(
                      title: "Similar Movies",
                      movies: movies,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
