import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  void _goToProducerInfoPage() async {
    Provider.of<GameState>(context, listen: false).setEra(selectedEra!);
    Navigator.pushNamed(context, '/producer');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Era"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(top: 25, bottom: 20, left: 25, right: 25),
                child: const Text(
                    "Select an Era - this will affect the people available for your movie"),
              ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToProducerInfoPage,
        tooltip: 'Select',
        child: const Text('Next'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
