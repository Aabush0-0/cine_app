import 'package:cinema_app/states/movie_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/movie_model.dart';
import '../states/movie_cubit.dart';
import '../widgets/movie_card.dart';

class MovieDetails extends StatefulWidget {
  final Movie iMovie;
  final MovieCubit cubit; // required cubit for favorites

  const MovieDetails({super.key, required this.iMovie, required this.cubit});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Movie movie;
  bool isLoadingSimilar = true;

  @override
  void initState() {
    super.initState();
    movie = widget.iMovie;

    // Fetch similar movies
    _loadSimilarMovies();
  }

  Future<void> _loadSimilarMovies() async {
    final similar = await widget.cubit.apiServices.similarMovies(movie.id);
    setState(() {
      movie = movie.copyWith(similarMovies: similar);
      isLoadingSimilar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = widget.cubit;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title ?? "Movie Details"),
        actions: [
          IconButton(
            icon: Icon(
              cubit.isFavorite(movie) ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () => setState(() {
              cubit.toggleFavorite(movie);
            }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Backdrop
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: movie.backdropPath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
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
              movie.title ?? "No Title",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Overview
            Text(movie.overview ?? "No Overview"),
            const SizedBox(height: 20),

            // Release date & vote
            Text(
              "Release Date: ${movie.releaseDate ?? "Unknown"}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Text(
              "Rating: ${movie.voteAverage?.toStringAsFixed(1) ?? "N/A"}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),

            // Similar movies
            const SizedBox(height: 20),
            if (isLoadingSimilar)
              const Center(child: CircularProgressIndicator())
            else if (movie.similarMovies != null &&
                movie.similarMovies!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Similar Movies",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: BlocBuilder<MovieCubit, MovieState>(
                      bloc: cubit, // listen to cubit changes
                      builder: (context, state) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movie.similarMovies!.length,
                          itemBuilder: (context, index) {
                            final similarMovie = movie.similarMovies![index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MovieDetails(
                                        iMovie: similarMovie,
                                        cubit: cubit,
                                      ),
                                    ),
                                  );
                                },
                                child: MovieCard(
                                  movie: similarMovie,
                                  cubit: cubit,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
