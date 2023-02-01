import 'package:ai_studio_client/components/MenuDrawer.dart';
import 'package:ai_studio_client/components/MovieListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api/api.dart';

import 'package:ai_studio_client/store/GameState.dart';

class MovieHallPage extends StatefulWidget {
  const MovieHallPage({super.key});

  @override
  State<MovieHallPage> createState() => _MovieHallPageState();
}

class _MovieHallPageState extends State<MovieHallPage> {
  Movie? selectedMovie;

  void _goToMovieProductionPage(context) {
    if (selectedMovie != null) {
      Provider.of<GameState>(context, listen: false)
          .setCurrentMovie(selectedMovie!);
      Navigator.pushReplacementNamed(context, '/production');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Hall'),
      ),
      drawer: MenuDrawer(context),
      body: Center(
          child: Consumer<GameState>(builder: (context, provider, child) {
        return ListView(
            children: provider.getStudioMovies().map<Widget>((movie) {
          var poster = Image.asset(
              height: 190, width: 100, 'images/poster-placeholder.jpg');

          if (movie?.posterUrl != null) {
            poster = Image.network(
                height: 190,
                width: 100,
                'http://localhost:3000/image?path=${movie!.posterUrl!}');
          }

          return MovieListItem(
            movie: movie,
            onTap: () {
              setState(() {
                selectedMovie = movie;
              });
            },
          );
        }).toList());
      })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _goToMovieProductionPage(context);
        },
        tooltip: 'Select Movie',
        child: const Text('Select'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
