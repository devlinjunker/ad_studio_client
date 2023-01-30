import 'package:flutter/material.dart';

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
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('New Movie'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Movie Hall'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Settings'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
