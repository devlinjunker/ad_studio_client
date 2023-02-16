import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/save.service.dart';
import '../store/StudioState.dart';

saveGame(context) {
  var studio = Provider.of<StudioState>(context, listen: false);

  showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        var message = "Save Game";
        var actions = [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Save'),
            onPressed: () {
              SaveService.saveGame('test', studio);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ];

        return AlertDialog(
            title: const Text('Save Game'),
            content: RichText(
              text: TextSpan(text: message),
            ),
            actions: actions);
      });
}

MenuDrawer(context) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        // const DrawerHeader(
        //   // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        //   decoration: BoxDecoration(
        //     color: Colors.blue,
        //   ),
        //   child: Text('AI Movie Sim'),
        // ),
        ListTile(
          title: const Text('AI Movie Sim'),
          tileColor: Colors.blue[50],
        ),
        ListTile(
          title: const Text('Main Menu'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        ListTile(
          title: const Text('New Movie'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/movies');
          },
        ),
        ListTile(
          title: const Text('Movie Hall'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/movie-hall');
          },
        ),
        ListTile(
          title: const Text('Save Game'),
          onTap: () {
            Navigator.pop(context);
            saveGame(context);
          },
        ),
        ListTile(
          title: const Text('Load Game'),
          onTap: () {
            SaveService.loadGame(
                'test', Provider.of<StudioState>(context, listen: false));
          },
        ),
        ListTile(
          title: const Text('Settings'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
