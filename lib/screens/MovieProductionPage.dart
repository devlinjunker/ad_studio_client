import 'package:ai_studio_client/AppScheme.dart';
import 'package:ai_studio_client/components/MenuDrawer.dart';
import 'package:ai_studio_client/store/GameState.dart';
import 'package:ai_studio_client/store/StudioState.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../components/ExpandableAction/ExpandableActionButton.dart';
import '../components/IssueModal.dart';
import '../components/MovieProductionLog.dart';
import '../components/ScandalModal.dart';
import '../components/TaglinesModal.dart';
import '../services/production.service.dart';

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
    if (Provider.of<StudioState>(context, listen: false).currentMovie == null) {
      Future.microtask(() => {Navigator.pushReplacementNamed(context, '/')});
    }
  }

  void generatePoster() async {
    final bool useGpt = false;
    var movie =
        Provider.of<StudioState>(context, listen: false).getCurrentMovie();

    StudioState studio = Provider.of<StudioState>(context, listen: false);

    var image = await ProductionService.generatePoster(movie, useGpt);
    studio.setCurrentMoviePoster(image);
  }

  void nextWeek() async {
    var game = Provider.of<GameState>(context, listen: false);
    var studio = Provider.of<StudioState>(context, listen: false);
    var movie = studio.getCurrentMovie();

    var log = await ProductionService.generateJournalLine(movie, true);
    studio.addCurrentMovieLog(game.currentDate!, log);
    game.stepWeek();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Movie Production"),
        ),
        drawer: MenuDrawer(context),
        body: Stack(children: [
          Container(
            color: Colors.orange[50],
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height),
            // Set the padding to display above the panel
            padding: const EdgeInsets.only(bottom: 90),
            child: Flex(direction: Axis.vertical, children: [
              Container(
                  color: Color.fromRGBO(70, 67, 36, 1),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 25),
                                child: Consumer<GameState>(
                                    builder: (context, provider, child) {
                                  String date = '';
                                  if (provider.currentDate != null) {
                                    date = DateFormat.yMMMd().format(
                                        provider.currentDate!.toDateTime());
                                  }

                                  return RichText(
                                    text: TextSpan(
                                        text: date,
                                        style: TextStyle(color: Colors.white)),
                                    textAlign: TextAlign.left,
                                  );
                                }))),
                        Expanded(
                          flex: 2,
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 25),
                              child: RichText(
                                text: const TextSpan(
                                    text: '\$0',
                                    style: TextStyle(color: Colors.white)),
                                textAlign: TextAlign.right,
                              )),
                        ),
                      ])),
              const Expanded(child: const MovieProductionLog()),
            ]),
          ),
          SlidingUpPanel(
            minHeight: 100,
            maxHeight: 200,
            panel: Container(
                color: AppScheme.background,
                constraints:
                    const BoxConstraints(minWidth: 400, minHeight: 200),
                padding: const EdgeInsets.only(top: 0, left: 25, right: 25),
                child:
                    Consumer<StudioState>(builder: (context, provider, child) {
                  var movie = provider.getCurrentMovie();

                  var tagline = movie?.tagline ?? '';
                  var children = <Widget>[
                    Container(
                        margin: const EdgeInsets.only(top: 15, left: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: '${movie?.name}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              textAlign: TextAlign.left,
                            ),
                            RichText(
                              text: TextSpan(
                                  text: '${tagline}',
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic)),
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
          )
        ]),
        floatingActionButton: ExpandableActionButton(
          angle: 90,
          children: [
            ActionButton(
              label: 'Next Week',
              onPressed: () => nextWeek(),
              icon: const Icon(Icons.fast_forward),
            ),
            ActionButton(
              label: 'Generate Poster',
              onPressed: () => generatePoster(),
              icon: const Icon(Icons.insert_photo),
            ),
            ActionButton(
              label: 'Generate Scandal',
              onPressed: () => showScandalModal(context),
              icon: const Icon(Icons.enhance_photo_translate),
            ),
            ActionButton(
              label: 'Generate Issue',
              onPressed: () => showIssueModal(context),
              icon: const Icon(Icons.local_phone),
            ),
            ActionButton(
              label: 'Generate Taglines',
              onPressed: () => showTaglinesModal(context),
              icon: const Icon(Icons.format_quote),
            ),
          ],
        ),
      );
    });
  }
}
