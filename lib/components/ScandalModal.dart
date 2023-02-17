import 'package:ai_studio_client/services/production.service.dart';
import 'package:ai_studio_client/store/GameState.dart';
import 'package:ai_studio_client/store/StudioState.dart';
import 'package:api/api.dart';
import 'package:float_column/float_column.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showScandalModal(BuildContext context) {
  Movie? movie =
      Provider.of<StudioState>(context, listen: false).getCurrentMovie();

  ProductionService.generateScandal(movie!, true).then((scandal) {
    Provider.of<StudioState>(context, listen: false)
        .setCurrentMovieScandal(scandal);
  });

  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const ScandalModal();
      });
}

class ScandalModal extends StatefulWidget {
  const ScandalModal({super.key});

  @override
  State<ScandalModal> createState() => _ScandalModalState();
}

class _ScandalModalState extends State<ScandalModal> {
  ScandalAction? selectedAction;

  @override
  void initState() {
    super.initState();
  }

  void selectAction(ScandalAction action) {
    Scandal scandal = Provider.of<StudioState>(context, listen: false)
        .getCurrentMovie()!
        .currentScandal!;

    Provider.of<StudioState>(context, listen: false).addCurrentMovieScandalLog(
        Provider.of<GameState>(context, listen: false).currentDate!,
        scandal,
        action);

    Provider.of<GameState>(context, listen: false).stepWeek();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudioState>(builder: (context, provider, child) {
      Movie? movie = provider.getCurrentMovie();
      Widget content = CircularProgressIndicator();

      if (movie?.currentScandal != null) {
        content = FloatColumn(
          children: [
            Floatable(
              float: FCFloat.start,
              padding: EdgeInsets.only(right: 8),
              child: Image.network(
                  height: 100,
                  width: 100,
                  'http://localhost:3000/image?path=${movie!.currentScandal!.imagePath}'),
            ),
            WrappableText(
                text: TextSpan(text: '${movie!.currentScandal!.description}')),
          ],
        );
      }

      List<Widget> children = [];
      if (movie?.currentScandal != null) {
        children = movie!.currentScandal!.actions.map((action) {
          return RadioListTile(
            title: Text("${action.description}"),
            value: action,
            groupValue: selectedAction,
            onChanged: (val) {
              setState(() {
                selectedAction = action;
              });
            },
          );
        }).toList();

        if (selectedAction != null) {
          children = [
            ...children,
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Select'),
              onPressed: () {
                selectAction(selectedAction!);
                Navigator.of(context).pop();
              },
            )
          ];
        }
      }

      return AlertDialog(
          title: const Text('Scandal'), content: content, actions: children);
    });
  }
}
