import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../states/movie_cubit.dart';
import '../states/movie_state.dart';
import '../widgets/movie_details.dart';
import '../widgets/movie_section.dart';
import '../widgets/searchbar_widget.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovieCubit>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(height: 25),
            SearchBarWidget(onChanged: (value) => cubit.searchMovies(value)),
            const SizedBox(height: 20),
            BlocBuilder<MovieCubit, MovieState>(
              builder: (context, state) {
                if (state.isLoading) return const CircularProgressIndicator();
                if (state.errorMessage != null)
                  return Text('Error: ${state.errorMessage}');

                List<Widget> sections = [];

                if (state.searchQuery.isNotEmpty) {
                  sections.add(
                    MovieSection(
                      title: "Search Results",
                      movies: state.filteredMovies,
                      cubit: cubit,
                      onMovieTap: (movie) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MovieDetails(iMovie: movie, cubit: cubit),
                          ),
                        );
                      },
                    ),
                  );
                }

                sections.addAll([
                  MovieSection(
                    title: "Popular Movies",
                    movies: state.popularMovies,
                    cubit: cubit,
                    onMovieTap: (movie) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MovieDetails(iMovie: movie, cubit: cubit),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  MovieSection(
                    title: "Top Rated Movies",
                    movies: state.topRatedMovies,
                    cubit: cubit,
                    onMovieTap: (movie) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MovieDetails(iMovie: movie, cubit: cubit),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  MovieSection(
                    title: "Upcoming Movies",
                    movies: state.upcomingMovies,
                    cubit: cubit,
                    onMovieTap: (movie) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MovieDetails(iMovie: movie, cubit: cubit),
                        ),
                      );
                    },
                  ),
                ]);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sections,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
