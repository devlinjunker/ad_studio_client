import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:built_value/serializer.dart';
import '../store/GameState.dart';

class EraSelectPage extends StatefulWidget {
  const EraSelectPage({super.key});

  @override
  State<EraSelectPage> createState() => _EraSelectPageState();
}

class _EraSelectPageState extends State<EraSelectPage> {
  Era? selectedEra;
  List<Era> eraOptions = [
    Era.n19801990,
    Era.n19902000,
    Era.n20002010,
    Era.n20102020,
    Era.n2020s
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
                        // Annoying but necessary for enums
                        title: Text((Era.serializer as PrimitiveSerializer)
                            .serialize(Serializers(), era) as String),
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
