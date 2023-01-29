import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Movie.dart';
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
      Provider.of<GameState>(context, listen: false).setMovies(fetchMovies());
      // Provider.of<GameState>(context, listen: false).setActors(
      //     fetchActors(Provider.of<GameState>(context, listen: false).startEra));
      // Provider.of<GameState>(context, listen: false).setActresses(fetchActresses());
    });
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 400),
                margin: const EdgeInsets.only(top: 25, left: 24, right: 24),
                child: const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToMovieSelectScreen,
        tooltip: 'Select',
        child: const Text('Next'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
