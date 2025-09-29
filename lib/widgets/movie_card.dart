import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../states/movie_cubit.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final MovieCubit cubit; // required cubit
  const MovieCard({super.key, required this.movie, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final isFav = cubit.isFavorite(movie);

    return Stack(
      children: [
        Container(
          width: 140,
          margin: const EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: movie.posterPath != null
                ? Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.movie, size: 50),
                  ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => cubit.toggleFavorite(movie),
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
