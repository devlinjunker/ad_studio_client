import 'package:api/api.dart';
import 'package:ai_studio_client/store/GameState.dart';
import 'package:dio/dio.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieProductionPage extends StatefulWidget {
  const MovieProductionPage({super.key});

  @override
  State<MovieProductionPage> createState() => _MovieProductionPageState();
}

class _MovieProductionPageState extends State<MovieProductionPage> {
  void _next() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Provider.of<GameState>(context, listen: false)?.getCurrentMovie() ==
        null) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  void generatePoster() async {
    final api = Api(
        dio: Dio(BaseOptions(
      baseUrl: 'http://localhost:3000',
      connectTimeout: 20000,
      receiveTimeout: 3000,
    ))).getDefaultApi();
    final bool useGpt = false; // bool |

    var movie =
        Provider.of<GameState>(context, listen: false).getCurrentMovie();

    var builder = GeneratePosterRequestBuilder();
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(movie!);
    builder.movie = movieBuilder;

    var image =
        await api.generatePoster(generatePosterRequest: builder.build());
    Provider.of<GameState>(context, listen: false)
        .setCurrentMoviePoster(image.data!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
            title: const Text("Select Movie"),
            automaticallyImplyLeading: false),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  constraints:
                      const BoxConstraints(minWidth: 100, maxWidth: 400),
                  margin: const EdgeInsets.only(top: 25, left: 24, right: 24),
                  child:
                      Consumer<GameState>(builder: (context, provider, child) {
                    var movie = provider.getCurrentMovie();

                    var children = <Widget>[
                      Text(
                          '${movie?.name} - ${movie?.actor?.name} - ${movie?.actress?.name}')
                    ];

                    if (movie?.posterUrl != null) {
                      children.insert(
                          0,
                          Image.network(
                              height: 190,
                              width: 100,
                              'http://localhost:3000/image?path=${movie!.posterUrl!}'));
                    }

                    return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: children);
                  })),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: generatePoster,
          tooltip: 'Generate',
          child: const Text('Poster'),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }
}
