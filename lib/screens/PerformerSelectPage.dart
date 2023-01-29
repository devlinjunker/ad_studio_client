import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Movie.dart';
import '../store/GameState.dart';

class PerformerSelectPage extends StatefulWidget {
  const PerformerSelectPage({super.key});

  @override
  State<PerformerSelectPage> createState() => _PerformerSelectPageState();
}

class _PerformerSelectPageState extends State<PerformerSelectPage> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Provider.of<GameState>(context, listen: false).setMovies(fetchMovies());
    // });
  }

  void _goToNextScreen() {
    Navigator.pushNamed(context, '/performers');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Performer"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 400),
                margin: const EdgeInsets.only(top: 25, left: 24, right: 24),
                child: Consumer<GameState>(builder: (context, provider, child) {
                  return Text(provider.getCurrentMovie()!.name);
                }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToNextScreen,
        tooltip: 'Select',
        child: const Text('Next'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
