import 'package:ai_studio_client/components/MenuDrawer.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  void _goToEraSelectPage(context) {
    Navigator.pushReplacementNamed(context, '/era');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: MenuDrawer(context),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 25, bottom: 25, left: 25, right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 25, bottom: 25),
                child: RichText(
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "'Welcome to ",
                      ),
                      TextSpan(
                        text: "AI Movie Studio",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      TextSpan(
                        text:
                            ", The Simulated Movie Production Game with Help from GPT-3, DALL-E and Stable Diffusion!",
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                'You are an aspiring producer looking to make your way through the trials and tribulations of Hollywood with your trusted AI Sidekicks!',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _goToEraSelectPage(context);
        },
        tooltip: 'Select Decade',
        child: const Text('Start'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
