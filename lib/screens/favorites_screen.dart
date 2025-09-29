import 'package:cinema_app/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../states/movie_cubit.dart';
import '../states/movie_state.dart';
import '../widgets/movie_card.dart';

class FavoritesScreen extends StatelessWidget {
  final String username;
  const FavoritesScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovieCubit>();

    return Scaffold(
      appBar: AppBar(title: Text("Favorites - $username")),
      body: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          // Collect all movies including similarMovies
          final allMovies = [
            ...state.popularMovies,
            ...state.topRatedMovies,
            ...state.upcomingMovies,
            // include similar movies from each list
            ...state.popularMovies.expand((m) => m.similarMovies ?? []),
            ...state.topRatedMovies.expand((m) => m.similarMovies ?? []),
            ...state.upcomingMovies.expand((m) => m.similarMovies ?? []),
          ];

          // Remove duplicates and only keep favorites
          final favMap = <int, Movie>{};
          for (var movie in allMovies) {
            if (cubit.isFavorite(movie)) {
              favMap[movie.id] = movie;
            }
          }

          final favMovies = favMap.values.toList();

          if (favMovies.isEmpty) {
            return const Center(child: Text("No favorites yet"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: favMovies.length,
            itemBuilder: (context, index) =>
                MovieCard(movie: favMovies[index], cubit: cubit),
          );
        },
      ),
    );
  }
}
