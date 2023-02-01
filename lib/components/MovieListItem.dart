import 'package:flutter/material.dart';
import 'package:api/api.dart';

class MovieListItem extends StatelessWidget {
  const MovieListItem({super.key, required this.movie, required this.onTap});

  final Movie movie;
  final VoidCallback onTap;

  showPopupMenu(context, GlobalKey key) async {
    RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position
    double y = position.dy;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
      items: [
        PopupMenuItem<String>(child: const Text('menu option 1'), value: '1'),
        PopupMenuItem<String>(child: const Text('menu option 2'), value: '2'),
        PopupMenuItem<String>(child: const Text('menu option 3'), value: '3'),
      ],
      elevation: 8.0,
    ).then((String? selected) {
      if (selected == null) return Future.value();

      if (selected == "1") {
        //code here
      } else if (selected == "2") {
        //code here
      } else {
        //code here
      }
      return Future.value();
    });
  }

  @override
  Widget build(BuildContext context) {
    var poster =
        Image.asset(height: 190, width: 100, 'images/poster-placeholder.jpg');

    if (movie?.posterUrl != null) {
      poster = Image.network(
          height: 190,
          width: 100,
          'http://localhost:3000/image?path=${movie!.posterUrl!}');
    }

    GlobalKey key = GlobalKey();

    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: poster,
                  ),
                  Expanded(
                    flex: 3,
                    child: MovieInfo(movie: movie),
                  ),
                  Container(
                    key: key,
                    child: IconButton(
                      onPressed: () => showPopupMenu(context, key),
                      icon: const Icon(
                        Icons.more_vert,
                        size: 16.0,
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}

class MovieInfo extends StatelessWidget {
  const MovieInfo({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            movie.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            '${movie.actor?.name}',
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            '${movie.actress?.name}',
            style: const TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
