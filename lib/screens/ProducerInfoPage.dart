import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/GameState.dart';

class ProducerInfoPage extends StatefulWidget {
  const ProducerInfoPage({super.key});

  @override
  State<ProducerInfoPage> createState() => _ProducerInfoPageState();
}

class _ProducerInfoPageState extends State<ProducerInfoPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final api =
          Api(basePathOverride: 'http://localhost:3000').getDefaultApi();
      final bool useGpt = false; // bool |

      var game = Provider.of<GameState>(context, listen: false);
      game.setMovies(api.fetchMovies(useGpt: useGpt));
      game.setActors(api.fetchActors(
          useGpt: useGpt,
          dates: Provider.of<GameState>(context, listen: false).startEra!));
      game.setActresses(api.fetchActresses(
          useGpt: useGpt,
          dates: Provider.of<GameState>(context, listen: false).startEra!));
      game.setCompanies(
          api.fetchCompanies(useGpt: useGpt, dates: game.startEra!));
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (Provider.of<GameState>(context, listen: false).startEra == null) {
      Future.microtask(() => {Navigator.pushReplacementNamed(context, '/era')});
    }
  }

  void _goToMovieSelectScreen() {
    Navigator.pushReplacementNamed(context, '/movies');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Producer Info"), automaticallyImplyLeading: false),
      body: Center(
          child: Container(
        margin: const EdgeInsets.only(top: 25, left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: RichText(
                    text: const TextSpan(
                        text: "We're excited to have you here! " +
                            "We are looking for the best and brightest studio executives to join us in creating the next blockbuster hit."))),
            Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: RichText(
                    text: const TextSpan(
                        text:
                            "In order to get started, we'll need a few pieces of information from you: we need to know who you are and what studio you represent."))),
            Container(
                margin: const EdgeInsets.only(bottom: 25),
                child: RichText(
                    text: const TextSpan(
                        text:
                            "We'll use this information to generate custom content and keep track of your progress as you play the game!"))),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  constraints: BoxConstraints(maxWidth: 400),
                  margin: const EdgeInsets.only(bottom: 25),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ))
            ]),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Studio Name',
              ),
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToMovieSelectScreen,
        tooltip: 'Select',
        child: const Text('Next'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
