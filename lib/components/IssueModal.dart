import 'package:ai_studio_client/services/production.service.dart';
import 'package:ai_studio_client/store/StudioState.dart';
import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showIssueModal(BuildContext context) {
  Movie? movie =
      Provider.of<StudioState>(context, listen: false).getCurrentMovie();

  ProductionService.generateIssue(movie!, true).then((issue) {
    Provider.of<StudioState>(context, listen: false)
        .setCurrentMovieIssue(issue);
  });

  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const IssueModal();
      });
}

class IssueModal extends StatefulWidget {
  const IssueModal({super.key});

  @override
  State<IssueModal> createState() => _IssueModalState();
}

class _IssueModalState extends State<IssueModal> {
  IssueAction? selectedAction;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudioState>(builder: (context, provider, child) {
      Movie? movie = provider.getCurrentMovie();
      Widget content = CircularProgressIndicator();

      if (movie?.currentIssue != null) {
        content = Text('${movie?.currentIssue?.description}');
      }

      List<Widget> children = [];
      if (movie?.currentIssue != null) {
        children = [
          ...movie!.currentIssue!.actions.map((action) {
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
          }).toList(),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Select'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ];
      }

      return AlertDialog(
          title: const Text('Issue'), content: content, actions: children);
    });
  }
}
