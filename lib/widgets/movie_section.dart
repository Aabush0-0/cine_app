import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../states/movie_cubit.dart';
import 'movie_card.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final MovieCubit cubit;
  final void Function(Movie)? onMovieTap;

  const MovieSection({
    super.key,
    required this.title,
    required this.movies,
    required this.cubit,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  if (onMovieTap != null) onMovieTap!(movie);
                },
                child: MovieCard(movie: movie, cubit: cubit),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
