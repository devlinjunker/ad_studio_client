import 'dart:convert';

import 'package:ai_studio_client/store/StudioState.dart';
import 'package:api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:built_value/serializer.dart';

class SaveService {
  static void saveGame(String name, StudioState state) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? saves = (await getSavedGameList());

    saves.add(name);
    prefs.setStringList('saves', saves);
    prefs.setString('save-${name}', getStateString(state));
  }

  static String getStateString(StudioState studio) {
    var builder = Serializers().toBuilder();
    builder.add(Performer.serializer);
    builder.add(PerformerGrossRevenue.serializer);
    var serializers = builder.build();
    dynamic state = {};
    state['movie'] = (Movie.serializer as PrimitiveSerializer)
        .serialize(serializers, studio.getCurrentMovie());

    state['movies'] = studio
        .getStudioMovies()
        .map((movie) => (Movie.serializer as PrimitiveSerializer)
            .serialize(serializers, movie))
        .toList();

    return jsonEncode(state);
  }

  static Future<List<String>> getSavedGameList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? saves = prefs.getStringList('saves');
    saves ??= [];

    return saves!;
  }

  static void loadGame(String name, StudioState state) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('save-${name}') == null) {
      throw Error();
    }
    parseStateString(prefs.getString('save-${name}')!, state);
  }

  static void parseStateString(String str, StudioState studio) {
    dynamic state = jsonDecode(str);
    List<dynamic> movie = state['movie'];
    List<dynamic> movies = state['movies'];

    Movie movieObj = (Movie.serializer as PrimitiveSerializer)
        .deserialize(serializers, movie);
    List<Movie> movieList = movies
        .map((obj) => (Movie.serializer as PrimitiveSerializer)
            .deserialize(serializers, movie) as Movie)
        .toList();

    studio.setCurrentMovie(movieObj);
    studio.setStudioMovies(movieList);
    return;
  }
}
