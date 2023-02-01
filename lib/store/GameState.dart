import 'package:api/api.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:built_collection/built_collection.dart';

class UIMovie {
  Movie? movie;
}

class GameState extends ChangeNotifier {
  String? startEra;

  Future<Response<BuiltList<Movie>>?> _movies = Future.value(null);
  Future<Response<BuiltList<Performer>>?> _actors = Future.value(null);
  Future<Response<BuiltList<Performer>>?> _actresses = Future.value(null);

  Movie? currentMovie;

  List<Movie> studioMovies = List.empty();

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

  void setActresses(Future<Response<BuiltList<Performer>>?> actresses) {
    _actresses = actresses;
    notifyListeners();
  }

  Future<Response<BuiltList<Performer>>?> getActresses() {
    return _actresses;
  }

  List<Movie> getStudioMovies() {
    return studioMovies;
  }

  void addMovie(Movie movie) {
    studioMovies = List.from(studioMovies)..add(movie);
    notifyListeners();
  }

  void setCurrentMovie(Movie movie) {
    currentMovie = movie;

    var oldMovie = studioMovies.where((m) => m.name == movie.name);
    if (oldMovie.length > 0) {
      var idx = studioMovies.indexOf(oldMovie.first);
      studioMovies.replaceRange(idx, idx + 1, [movie]);
    } else {
      return addMovie(movie);
    }

    notifyListeners();
  }

  Movie? getCurrentMovie() {
    return currentMovie;
  }

  void setCurrentMovieActor(Performer performer) {
    var builder = PerformerBuilder();
    builder.replace(performer);
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(currentMovie!);
    movieBuilder.actor = builder;
    setCurrentMovie(movieBuilder.build());
    notifyListeners();
  }

  void setCurrentMovieActress(Performer performer) {
    var builder = PerformerBuilder();
    builder.replace(performer);
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(currentMovie!);
    movieBuilder.actress = builder;
    setCurrentMovie(movieBuilder.build());
    notifyListeners();
  }

  void setCurrentMoviePoster(String url) {
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(currentMovie!);
    movieBuilder.posterUrl = url;
    setCurrentMovie(movieBuilder.build());
    notifyListeners();
  }
}
