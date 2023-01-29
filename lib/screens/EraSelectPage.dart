import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Movie.dart';
import '../store/GameState.dart';

class EraSelectPage extends StatefulWidget {
  const EraSelectPage({super.key});

  @override
  State<EraSelectPage> createState() => _EraSelectPageState();
}

class _EraSelectPageState extends State<EraSelectPage> {
  String? selectedEra;
  List<String> eraOptions = [
    '1980-1990',
    '1990-2000',
    '2000-2010',
    '2010-2020',
    '2020s'
  ];

  @override
  void initState() {
    super.initState();
  }

  void _goToProducerInfoPage() {
    Provider.of<GameState>(context, listen: false).setEra(selectedEra!);
    Navigator.pushNamed(context, '/producer');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Era"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
                "Select an Era - this will affect the people available for your movie"),
            ...(eraOptions
                .map((era) => RadioListTile(
                      title: Text(era),
                      value: era,
                      groupValue: selectedEra,
                      onChanged: (val) {
                        setState(() {
                          selectedEra = era;
                        });
                      },
                    ))
                .toList())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToProducerInfoPage,
        tooltip: 'Select',
        child: const Text('Next'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
