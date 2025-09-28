import 'package:cinema_app/widgets/movie_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/networks/api_services.dart';
import '../states/movie_cubit.dart';
import '../states/movie_state.dart';
import '../widgets/movie_card.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late final MovieCubit _movieCubit;

  @override
  void initState() {
    super.initState();
    _movieCubit = MovieCubit(ApiServices());
    _movieCubit.fetchMovies();
  }

  @override
  void dispose() {
    _movieCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _movieCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Upcoming Movies',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
        ),
        body: BlocBuilder<MovieCubit, MovieState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final movies = state.upcomingMovies;

            if (movies.isEmpty) {
              return const Center(child: Text('No upcoming movies available.'));
            }

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
                        builder: (_) => MovieDetails(iMovie: movie),
                      ),
                    );
                  },
                  child: MovieCard(movie: movie),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
