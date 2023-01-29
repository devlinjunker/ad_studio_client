import 'package:api/api.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:built_collection/built_collection.dart';

class GameState extends ChangeNotifier {
  String? startEra;

  Future<Response<BuiltList<Movie>>?> _movies = Future.value(null);
  Future<Response<BuiltList<Performer>>?> _actors = Future.value(null);

  Movie? currentMovie;

  void setEra(String era) {
    startEra = era;
    notifyListeners();
  }

  void setMovies(Future<Response<BuiltList<Movie>>?> movies) {
    _movies = movies;
    notifyListeners();
  }

  Future<Response<BuiltList<Movie>>?> getMovies() {
    return _movies;
  }

  void setActors(Future<Response<BuiltList<Performer>>?> actors) {
    _actors = actors;
    notifyListeners();
  }

  Future<Response<BuiltList<Performer>>?> getActors() {
    return _actors;
  }

  void setCurrentMovie(Movie movie) {
    currentMovie = movie;
    notifyListeners();
  }

  Movie? getCurrentMovie() {
    return currentMovie;
  }
}
