import 'package:ai_studio_client/models/Movie.dart';
import 'package:flutter/foundation.dart';

class GameState extends ChangeNotifier {
  String? startEra;

  Future<List<Movie>?> _movies = Future.value(null);
  Movie? currentMovie;

  void setEra(String era) {
    startEra = era;
    notifyListeners();
  }

  void setMovies(Future<List<Movie>> movies) {
    _movies = movies;
    notifyListeners();
  }

  Future<List<Movie>?> getMovies() {
    return _movies;
  }

  void setCurrentMovie(Movie movie) {
    currentMovie = movie;
    notifyListeners();
  }

  Movie? getCurrentMovie() {
    return currentMovie;
  }
}
