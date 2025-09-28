import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/networks/api_services.dart';
import '../states/movie_cubit.dart';
import '../states/movie_state.dart';
import '../widgets/movie_section.dart';
import '../widgets/searchbar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieCubit(ApiServices())..fetchMovies(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 25),
                BlocBuilder<MovieCubit, MovieState>(
                  builder: (context, state) {
                    return SearchBarWidget(
                      onChanged: (value) =>
                          context.read<MovieCubit>().searchMovies(value),
                    );
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<MovieCubit, MovieState>(
                  builder: (context, state) {
                    if (state.isLoading) return CircularProgressIndicator();
                    if (state.errorMessage != null)
                      return Text('Error: ${state.errorMessage}');

                    if (state.searchQuery.isNotEmpty) {
                      return MovieSection(
                        title: "Search Results",
                        movies: state.filteredMovies,
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MovieSection(
                          title: "Popular Movies",
                          movies: state.popularMovies,
                        ),
                        const SizedBox(height: 20),
                        MovieSection(
                          title: "Top Rated Movies",
                          movies: state.topRatedMovies,
                        ),
                        const SizedBox(height: 20),
                        MovieSection(
                          title: "Upcoming Movies",
                          movies: state.upcomingMovies,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
