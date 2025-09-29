import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../states/movie_cubit.dart';
import '../states/movie_state.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_details.dart';

class MoviesScreen extends StatelessWidget {
  final String username;
  const MoviesScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovieCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text("Upcoming Movies")),
      body: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          if (state.isLoading)
            return const Center(child: CircularProgressIndicator());

          final movies = state.upcomingMovies;
          if (movies.isEmpty)
            return const Center(child: Text('No upcoming movies available.'));

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetails(iMovie: movie, cubit: cubit),
                    ),
                  );
                },
                child: MovieCard(movie: movie, cubit: cubit),
              );
            },
          );
        },
      ),
    );
  }
}
