import 'dart:math';

import 'package:ai_studio_client/components/MenuDrawer.dart';
import 'package:ai_studio_client/components/MovieListItem.dart';
import 'package:ai_studio_client/store/GameState.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:api/api.dart';

import '../store/StudioState.dart';

class StudioSelectPage extends StatefulWidget {
  const StudioSelectPage({super.key});

  @override
  State<StudioSelectPage> createState() => _StudioSelectPageState();
}

class _StudioSelectPageState extends State<StudioSelectPage> {
  MovieCompany? selectedStudio;
  late Future<Response<BuiltList<MovieCompany>>?> studios;

  final currencyFormatter = NumberFormat.simpleCurrency(decimalDigits: 0);

  void _goToPerformerSelectScreen(context) {
    if (selectedStudio != null) {
      // Provider.of<StudioState>(context, listen: false)
      //     .setCurrentMovie(selectedMovie!);
      Navigator.pushReplacementNamed(context, '/performers');
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (Provider.of<StudioState>(context, listen: false).currentMovie == null) {
      Future.microtask(() => {Navigator.pushReplacementNamed(context, '/')});
    }
  }

  void initState() {
    super.initState();
    setState(() => {
          studios =
              Provider.of<GameState>(context, listen: false).getCompanies()
        });
  }

  void _openStudioNegotiationModal(context) {
    num budget = 0;
    if (selectedStudio!.budget != null) {
      budget = selectedStudio!.budget!;
    } else {
      var chance = Random().nextDouble();
      if (chance < 0.25) {
        budget = (5 + Random().nextInt(10)) * 1000000;
      }

      MovieCompanyBuilder builder = selectedStudio!.toBuilder();
      builder.replace(selectedStudio!);
      builder.budget = budget;
      var studio = builder.build();
      setState(() => {selectedStudio = builder.build()});

      // HACK: doesn't seem very good
      studios.then((list) {
        var studioList = list!.data!;
        var oldStudio = studioList.where((m) => m.name == selectedStudio!.name);
        if (oldStudio.length > 0) {
          var idx = studioList.indexOf(oldStudio.first);
          var builder = studioList.toBuilder();
          builder.replaceRange(idx, idx + 1, [studio]);
          setState(() => {
                studios = Future.value(Response(
                    data: builder.build(), requestOptions: list.requestOptions))
              });
        }
      });
    }

    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          var message =
              "${selectedStudio!.name} has declined to fund your film";
          var actions = [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ];

          if (budget != 0) {
            message =
                "${selectedStudio!.name} offers a budget of ${currencyFormatter.format(budget)}";
            actions = [
              ...actions,
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Select'),
                onPressed: () {
                  Provider.of<StudioState>(context, listen: false)
                      .setCurrentMovieBudget(budget);
                  _goToPerformerSelectScreen(context);
                },
              )
            ];
          }

          return AlertDialog(
              title: const Text('Studio Funding'),
              content: RichText(
                text: TextSpan(text: message),
              ),
              actions: actions);
        });
  }

  @override
  Widget build(BuildContext context) {
    var button;
    if (selectedStudio != null) {
      button = FloatingActionButton(
        onPressed: () {
          _openStudioNegotiationModal(context);
        },
        tooltip: 'Select',
        child: const Text('Select'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Hall'),
      ),
      drawer: MenuDrawer(context),
      body: Center(
          child: Consumer<GameState>(builder: (context, provider, child) {
        return FutureBuilder<Response<BuiltList<MovieCompany>>?>(
            future: studios,
            builder: (context, snapshot) {
              if (snapshot?.data?.data == null) {
                return CircularProgressIndicator();
              }

              return ListView(
                  children: snapshot!.data!.data!.map<Widget>((studio) {
                return ListTile(
                  title: RichText(
                      text: TextSpan(
                          style: studio.budget == 0
                              ? TextStyle(
                                  decoration: TextDecoration.lineThrough)
                              : null,
                          text: studio.name +
                              ((studio.budget != null && studio.budget! > 0)
                                  ? " (${currencyFormatter.format(studio.budget!)})"
                                  : ""))),
                  onTap: () {
                    setState(() {
                      selectedStudio = studio;
                    });
                  },
                );
              }).toList());
            });
      })),
      floatingActionButton:
          button, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
