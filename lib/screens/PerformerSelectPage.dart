import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:built_collection/built_collection.dart';
import '../store/GameState.dart';

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
                      future: provider.getActors(),
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
