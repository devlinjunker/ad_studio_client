import 'dart:math';

import 'package:ai_studio_client/components/MenuDrawer.dart';
import 'package:ai_studio_client/components/MovieListItem.dart';
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

class Studio {
  String name;
  num budget;

  Studio(this.name, this.budget);
}

class _StudioSelectPageState extends State<StudioSelectPage> {
  Studio? selectedStudio;

  final currencyFormatter = NumberFormat.simpleCurrency(decimalDigits: 0);

  final studios = [
    Studio('Miramax', (5 + Random().nextInt(10)) * 1000000),
    Studio('Fox', (5 + Random().nextInt(10)) * 1000000),
    Studio('Columbia', (5 + Random().nextInt(10)) * 1000000)
  ];

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

  void _openStudioNegotiationModal(context) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Studio Pitch'),
              content: RichText(
                text: TextSpan(
                    text:
                        "${selectedStudio!.name} offers a budget of ${currencyFormatter.format(selectedStudio!.budget)}"),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Select'),
                  onPressed: () {
                    Provider.of<StudioState>(context, listen: false)
                        .setCurrentMovieBudget(selectedStudio!.budget);
                    _goToPerformerSelectScreen(context);
                  },
                )
              ]);
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
          child: Consumer<StudioState>(builder: (context, provider, child) {
        return ListView(
            children: studios.map<Widget>((studio) {
          return ListTile(
            title: RichText(text: TextSpan(text: studio.name)),
            onTap: () {
              setState(() {
                selectedStudio = studio;
              });
            },
          );
        }).toList());
      })),
      floatingActionButton:
          button, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
