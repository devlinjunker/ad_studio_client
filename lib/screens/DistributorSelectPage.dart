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

class DistributorSelectPage extends StatefulWidget {
  const DistributorSelectPage({super.key});

  @override
  State<DistributorSelectPage> createState() => _DistributorSelectPage();
}

class _DistributorSelectPage extends State<DistributorSelectPage> {
  MovieCompany? selectedDistributor;
  late Future<Response<BuiltList<MovieCompany>>?> distributors;

  final currencyFormatter = NumberFormat.simpleCurrency(decimalDigits: 0);

  void _goToPerformerSelectScreen(context) {
    if (selectedDistributor != null) {
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
          distributors =
              Provider.of<GameState>(context, listen: false).getCompanies()
        });
  }

  void _openStudioNegotiationModal(context) {
    num budget = 0;
    if (selectedDistributor!.budget != null) {
      budget = selectedDistributor!.budget!;
    } else {
      var chance = Random().nextDouble();
      if (chance < 0.25) {
        budget = (5 + Random().nextInt(10)) * 1000000;
      }

      MovieCompanyBuilder builder = selectedDistributor!.toBuilder();
      builder.replace(selectedDistributor!);
      builder.budget = budget;
      var studio = builder.build();
      setState(() => {selectedDistributor = builder.build()});

      // HACK: doesn't seem very good
      distributors.then((list) {
        var distributorList = list!.data!;
        var oldStudio =
            distributorList.where((m) => m.name == selectedDistributor!.name);
        if (oldStudio.length > 0) {
          var idx = distributorList.indexOf(oldStudio.first);
          var builder = distributorList.toBuilder();
          builder.replaceRange(idx, idx + 1, [studio]);
          setState(() => {
                distributors = Future.value(Response(
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
              "${selectedDistributor!.name} has declined to fund your film";
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
                "${selectedDistributor!.name} offers a budget of ${currencyFormatter.format(budget)}";
            actions = [
              ...actions,
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Select'),
                onPressed: () {
                  Provider.of<StudioState>(context, listen: false)
                      .setCurrentMovieDistributor(selectedDistributor!, budget);

                  _goToPerformerSelectScreen(context);
                },
              )
            ];
          }

          return AlertDialog(
              title: const Text('Distributor Funding'),
              content: RichText(
                text: TextSpan(text: message),
              ),
              actions: actions);
        });
  }

  @override
  Widget build(BuildContext context) {
    var button;
    if (selectedDistributor != null) {
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
        title: const Text('Choose Distributor'),
      ),
      drawer: MenuDrawer(context),
      body: Center(
          child: Consumer<GameState>(builder: (context, provider, child) {
        return FutureBuilder<Response<BuiltList<MovieCompany>>?>(
            future: distributors,
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
                      selectedDistributor = studio;
                      _openStudioNegotiationModal(context);
                    });
                  },
                );
              }).toList());
            });
      })),
    );
  }
}
