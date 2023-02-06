import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_studio_client/store/StudioState.dart';

class MovieProductionLog extends StatelessWidget {
  const MovieProductionLog({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Consumer<StudioState>(builder: (context, provider, child) {
            var logs = [];
            if (provider.currentMovie?.log != null &&
                provider.currentMovie!.log!.isNotEmpty) {
              logs = provider.currentMovie!.log!.reversed.map((log) {
                return Row(children: [
                  Container(
                      constraints: BoxConstraints(
                          maxWidth: viewportConstraints.maxWidth - 50),
                      child: Flex(direction: Axis.vertical, children: [
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: RichText(
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: log.date,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: log.log.oneOf.value.toString(),
                              )
                            ]))),
                        const Divider(
                          color: Colors.black,
                          height: 5,
                          indent: 30,
                          endIndent: 30,
                        )
                      ])),
                ]);
              }).toList();
            }
            ScrollController listScrollController = ScrollController();
            return Container(
                constraints:
                    BoxConstraints(maxWidth: viewportConstraints.maxWidth),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    RichText(
                        text: const TextSpan(
                      text: "Production Log",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    )),
                  ]),
                  Container(
                      constraints: BoxConstraints(
                          maxHeight: viewportConstraints.maxHeight - 40,
                          maxWidth: viewportConstraints.maxWidth),
                      child: ListView(children: [...logs]))
                ]));
          }));
    });
  }
}
