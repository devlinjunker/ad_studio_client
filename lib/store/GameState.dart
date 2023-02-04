import 'dart:math';
import 'package:api/api.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:built_collection/built_collection.dart';

class UIMovie {
  Movie? movie;
}

class GameState extends ChangeNotifier {
  Date? currentDate;
  Era? startEra;

  Future<Response<BuiltList<Movie>>?> _movies = Future.value(null);
  Future<Response<BuiltList<Performer>>?> _actors = Future.value(null);
  Future<Response<BuiltList<Performer>>?> _actresses = Future.value(null);

  void setEra(Era era) {
    startEra = era;
    int startDay = Random().nextInt(365 * 3);
    print(startDay);
    Date startDate = Date(1980, 0, startDay);
    switch (era) {
      case Era.n19801990:
        startDate = Date(1980, 0, startDay);
        break;
      case Era.n19902000:
        startDate = Date(1990, 0, startDay);
        break;
      case Era.n20002010:
        startDate = Date(2000, 0, startDay);
        break;
      case Era.n20102020:
        startDate = Date(2010, 0, startDay);
        break;
      case Era.n2020s:
        startDate = Date(2020, 0, startDay);
        break;
    }
    currentDate = startDate;

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

  void stepWeek() {
    currentDate =
        Date(currentDate!.year, currentDate!.month, currentDate!.day + 7);
    notifyListeners();
  }
}
