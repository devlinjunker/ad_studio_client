import 'package:ai_studio_client/components/MenuDrawer.dart';
import 'package:api/api.dart';
import 'package:ai_studio_client/store/GameState.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
    if (Provider.of<GameState>(context, listen: false).currentMovie == null) {
      Future.microtask(() => {Navigator.pushReplacementNamed(context, '/')});
    }
  }

  void generatePoster() async {
    final api = Api(
        dio: Dio(BaseOptions(
      baseUrl: 'http://localhost:3000',
      connectTimeout: 20000,
      receiveTimeout: 3000,
    ))).getDefaultApi();

    final bool useGpt = false;
    var movie =
        Provider.of<GameState>(context, listen: false).getCurrentMovie();

    var builder = GeneratePosterRequestBuilder();
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(movie!);
    builder.movie = movieBuilder;
    builder.useGpt = useGpt;

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
          title: const Text("Movie Production"),
        ),
        drawer: MenuDrawer(context),
        body: SlidingUpPanel(
          minHeight: 100,
          maxHeight: 300,
          panel: Container(
              constraints: const BoxConstraints(minWidth: 400, minHeight: 300),
              margin: const EdgeInsets.only(top: 0, left: 25, right: 25),
              child: Consumer<GameState>(builder: (context, provider, child) {
                var movie = provider.getCurrentMovie();

                var children = <Widget>[
                  Container(
                      margin: const EdgeInsets.only(top: 25, left: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: '${movie?.name}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          RichText(
                            text: TextSpan(text: '${movie?.actor?.name}'),
                            textAlign: TextAlign.left,
                          ),
                          RichText(
                            text: TextSpan(text: '${movie?.actress?.name}'),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ))
                ];

                var child = Image.asset(
                    height: 190, width: 100, 'images/poster-placeholder.jpg');

                if (movie?.posterUrl != null) {
                  child = Image.network(
                      height: 190,
                      width: 100,
                      'http://localhost:3000/image?path=${movie!.posterUrl!}');
                }
                children.insert(
                    0,
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [child]));

                return Container(
                    constraints: const BoxConstraints(minHeight: 300),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: children));
              })),
          // Background behind sliding panel
          body: Center(
            child: Text("This is the Widget behind the sliding panel"),
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
