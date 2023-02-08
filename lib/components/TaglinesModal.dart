import 'package:ai_studio_client/services/production.service.dart';
import 'package:ai_studio_client/store/StudioState.dart';
import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showTaglinesModal(BuildContext context) {
  Movie? movie =
      Provider.of<StudioState>(context, listen: false).getCurrentMovie();

  ProductionService.generateTaglines(movie!, true).then((taglines) {
    Provider.of<StudioState>(context, listen: false)
        .setTaglines(movie, taglines.toList());
  });

  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const TaglinesModal();
      });
}

class TaglinesModal extends StatefulWidget {
  const TaglinesModal({super.key});

  @override
  State<TaglinesModal> createState() => _TaglinesModalState();
}

class _TaglinesModalState extends State<TaglinesModal> {
  String? selectedTagline;

  @override
  void initState() {
    super.initState();
  }

  void addTagline() {
    Provider.of<StudioState>(context, listen: false)
        .addCurrentMovieTagline(selectedTagline!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudioState>(builder: (context, provider, child) {
      List<String>? taglines = provider.taglines[provider.getCurrentMovie()];
      Widget content = CircularProgressIndicator();

      if (taglines != null) {
        content = Text('');
      }

      List<Widget> children = [];
      if (taglines != null) {
        children = [
          ...taglines.map((line) {
            return RadioListTile(
              title: Text(line),
              value: line,
              groupValue: selectedTagline,
              onChanged: (val) {
                setState(() {
                  selectedTagline = line;
                });
              },
            );
          }).toList(),
        ];
        if (selectedTagline != null) {
          children = [
            ...children,
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Select'),
              onPressed: () {
                addTagline();
                Navigator.of(context).pop();
              },
            )
          ];
        }
      }

      return AlertDialog(
          title: const Text('Select Tagline'),
          content: content,
          actions: children);
    });
  }
}
