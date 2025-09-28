import 'package:flutter/material.dart';

import '../models/movie_model.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final double width;
  final double height;

  const MovieCard({
    super.key,
    required this.movie,
    this.width = 150,
    this.height = 250,
  });

  @override
  Widget build(BuildContext context) {
    final posterUrl = (movie.posterPath?.isNotEmpty ?? false)
        ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
        : null;

    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Expanded(
            child: posterUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      posterUrl,
                      fit: BoxFit.cover,
                      width: width,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.movie, size: 50),
                  ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: width,
            child: Text(
              movie.title ?? 'No Title',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
