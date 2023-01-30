import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:built_collection/built_collection.dart';
import '../store/GameState.dart';

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
      Navigator.pushReplacementNamed(context, '/era');
    }
  }

  void _goToNextScreen() {
    final args =
        ModalRoute.of(context)!.settings.arguments as PerformerSelectPageArgs?;

    if (args?.type == 'actress') {
      Provider.of<GameState>(context, listen: false)
          .setCurrentMovieActress(selectedPerformer!);
      Navigator.pushNamed(context, '/production');
    } else {
      Provider.of<GameState>(context, listen: false)
          .setCurrentMovieActor(selectedPerformer!);
      Navigator.pushNamed(context, '/performers',
          arguments: PerformerSelectPageArgs('actress'));
    }
  }

  @override
  Widget build(BuildContext context) {
    PerformerSelectPageArgs? args;
    final settings = ModalRoute.of(context)!.settings;
    if (settings?.arguments != null) {
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
                              .map((performer) => RadioListTile(
                                    title: Text("${performer.name}"),
                                    value: performer,
                                    groupValue: selectedPerformer,
                                    onChanged: (val) {
                                      setState(() {
                                        selectedPerformer = performer;
                                      });
                                    },
                                  ))
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
