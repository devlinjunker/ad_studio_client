import 'package:ai_studio_client/models/Movie.dart';
import 'package:flutter/foundation.dart';

class GameState extends ChangeNotifier {
  /// Internal, private state of the cart.
  Future<List<Movie>?> _movies = Future.value(null);
  Movie? current_movie = null;

  void setMovies(Future<List<Movie>> movies) {
    _movies = movies;
    notifyListeners();
  }

  Future<List<Movie>?> getMovies() {
    return _movies;
  }

  void setCurrentMovie(Movie movie) {
    current_movie = movie;
    notifyListeners();
  }

  Movie? getMovie() {
    return current_movie;
  }
}
