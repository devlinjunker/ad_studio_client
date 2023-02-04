import 'package:api/api.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:built_collection/built_collection.dart';
import 'package:intl/intl.dart';
import 'package:one_of/one_of.dart';

class UIMovie {
  Movie? movie;
}

class StudioState extends ChangeNotifier {
  List<Movie> studioMovies = List.empty();

  Movie? currentMovie;

  Map<Movie, List<String>> taglines = {};

  List<Movie> getStudioMovies() {
    return studioMovies;
  }

  void setTaglines(Movie movie, List<String> lines) {
    taglines[movie] = lines;
    notifyListeners();
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

  void setCurrentMovieScandal(Scandal scandal) {
    var builder = ScandalBuilder();
    builder.replace(scandal);
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(currentMovie!);
    movieBuilder.currentScandal = builder;
    setCurrentMovie(movieBuilder.build());
    notifyListeners();
  }

  void setCurrentMovieIssue(Issue issue) {
    var builder = IssueBuilder();
    builder.replace(issue);
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(currentMovie!);
    movieBuilder.currentIssue = builder;
    setCurrentMovie(movieBuilder.build());
    notifyListeners();
  }

  void addCurrentMovieLog(Date date, String log) {
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(currentMovie!);
    var logBuilder = MovieLogInnerBuilder();
    logBuilder.date = DateFormat.yMMMd().format(date.toDateTime());
    logBuilder.log = MovieLogInnerLogBuilder();
    logBuilder.log.oneOf = OneOf.fromValue1<String>(value: log);
    movieBuilder.log.add(logBuilder.build());
    movieBuilder.currentWeek = currentMovie!.currentWeek + 1;
    setCurrentMovie(movieBuilder.build());
    notifyListeners();
  }
}
