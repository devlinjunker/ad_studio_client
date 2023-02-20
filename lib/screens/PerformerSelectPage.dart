import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:built_collection/built_collection.dart';
import '../store/GameState.dart';
import '../store/StudioState.dart';

class PerformerSelectPageArgs {
  String type;

  PerformerSelectPageArgs(this.type);
}

class PerformerSelectPage extends StatefulWidget {
  const PerformerSelectPage({super.key});

  @override
  State<PerformerSelectPage> createState() => _PerformerSelectPageState();
}

class _PerformerSelectPageState extends State<PerformerSelectPage> {
  Performer? selectedPerformer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (Provider.of<GameState>(context, listen: false).startEra == null) {
      Future.microtask(() => {Navigator.pushReplacementNamed(context, '/era')});
    }
  }

  void _goToNextScreen() {
    Movie movie =
        Provider.of<StudioState>(context, listen: false).getCurrentMovie()!;

    var price = selectedPerformer!.grossRevenue / 100;

    if ((movie!.budget - movie!.cost) > price) {
      final args = ModalRoute.of(context)!.settings.arguments
          as PerformerSelectPageArgs?;

      if (args?.type == 'actress') {
        Provider.of<StudioState>(context, listen: false)
            .setCurrentMovieActress(selectedPerformer!, price);
        Navigator.pushNamed(context, '/production');
      } else {
        Provider.of<StudioState>(context, listen: false)
            .setCurrentMovieActor(selectedPerformer!, price);
        Navigator.pushNamed(context, '/performers',
            arguments: PerformerSelectPageArgs('actress'));
      }
    } else {
      showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            var actions = [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ];

            return AlertDialog(
                title: const Text('Contract'),
                content: RichText(
                  text: TextSpan(
                      text:
                          'Actor is asking for ${price} but your remaining budget is ${movie.budget - movie.cost}'),
                ),
                actions: actions);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    PerformerSelectPageArgs? args;
    final settings = ModalRoute.of(context)!.settings;
    if (settings.arguments != null) {
      args = settings.arguments as PerformerSelectPageArgs;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Select Performer"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  constraints:
                      const BoxConstraints(minWidth: 100, maxWidth: 400),
                  margin: const EdgeInsets.only(top: 25, left: 24, right: 24),
                  child:
                      Consumer<GameState>(builder: (context, provider, child) {
                    return FutureBuilder<Response<BuiltList<Performer>>?>(
                      future: args?.type == 'actress'
                          ? provider.getActresses()
                          : provider.getActors(),
                      builder: (context, snapshot) {
                        List<Widget> children = <Widget>[
                          CircularProgressIndicator()
                        ];

                        if (snapshot.hasData && snapshot.data != null) {
                          children = snapshot.data!.data!
                              .map((performer) {
                                var price = performer.grossRevenue / 100000000;
                                return RadioListTile(
                                  title: Text(
                                      "${performer.name} - (\$${price} Million)"),
                                  value: performer,
                                  groupValue: selectedPerformer,
                                  onChanged: (val) {
                                    setState(() {
                                      selectedPerformer = performer;
                                    });
                                  },
                                );
                              })
                              .cast<Widget>()
                              .toList();
                        } else if (snapshot.hasError) {
                          children = <Widget>[Text('${snapshot.error}')];
                        }

                        return Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: children),
                        );
                      },
                    );
                  }))
            ],
          ),
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
