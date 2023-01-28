import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Movie>> fetchMovies() async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/movies?useGpt=false'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> movieJson = jsonDecode(response.body);
    // List<String>? movieJson = jsonArray != null ? List.from(jsonArray) : null;

    List<Movie> movies = List.empty();
    if (movieJson != null) {
      movies = List.from(movieJson.map((json) => Movie.fromJson(json)));
    }
    return movies;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Movie {
  String name;
  String synopsis;
  int? productionTime;
  int? budget;

  int? romance;
  int? thrill;
  int? family;
  int? action;
  int? drama;
  int? mystery;
  int? comedy;
  int? sex;
  int? violence;
  int? drugs;

  String? posterUrl;
  Object? actor;
  Object? actress;

  String? tagline;

  // media?: {
  //   [key: string]: number
  // };
  int cost = 0;

  Movie(
      {required this.name,
      required this.synopsis,
      productionTime,
      budget,
      romance,
      thrill,
      family,
      action,
      drama,
      mystery,
      comedy,
      sex,
      violence,
      drugs});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      name: json['name'],
      synopsis: json['synopsis'],
      productionTime: json['production_time'],
    );
  }
}
