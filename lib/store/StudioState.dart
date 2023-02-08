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

  num getCurrentMovieMediaTotal() {
    num mediaTotal = 0;
    if (currentMovie!.media != null) {
      currentMovie!.media!.forEach((key, val) {
        mediaTotal += val;
      });
    }
    return mediaTotal;
  }

  void setCurrentMovieActor(Performer performer) {
    var builder = PerformerBuilder();
    builder.replace(performer);
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(currentMovie!);
    movieBuilder.actor = builder;
    setCurrentMovie(movieBuilder.build());
  }

  void setCurrentMovieActress(Performer performer) {
    var builder = PerformerBuilder();
    builder.replace(performer);
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(currentMovie!);
    movieBuilder.actress = builder;
    setCurrentMovie(movieBuilder.build());
  }

  void setCurrentMoviePoster(String url) {
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(currentMovie!);
    movieBuilder.posterUrl = url;
    setCurrentMovie(movieBuilder.build());
  }

  void setCurrentMovieScandal(Scandal scandal) {
    var builder = ScandalBuilder();
    builder.replace(scandal);
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(currentMovie!);
    movieBuilder.currentScandal = builder;
    setCurrentMovie(movieBuilder.build());
  }

  void setCurrentMovieIssue(Issue issue) {
    var builder = IssueBuilder();
    builder.replace(issue);
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(currentMovie!);
    movieBuilder.currentIssue = builder;
    setCurrentMovie(movieBuilder.build());
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
  }

  void addCurrentMovieScandal(
      Date date, Scandal scandal, ScandalAction action) {
    ScandalActionBuilder actionBuilder = ScandalActionBuilder();
    actionBuilder.replace(action);
    ScandalBuilder builder = ScandalBuilder();
    builder.replace(scandal);
    builder.selectedAction = actionBuilder;
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(currentMovie!);
    var logBuilder = MovieLogInnerBuilder();
    logBuilder.date = DateFormat.yMMMd().format(date.toDateTime());
    logBuilder.log = MovieLogInnerLogBuilder();
    logBuilder.log.oneOf = OneOf.fromValue1<Scandal>(value: scandal);
    movieBuilder.log.add(logBuilder.build());
    movieBuilder.currentScandal = null;
    movieBuilder.cost = movieBuilder.cost! + action.financial;

    var newMedia = 1;
    MapBuilder<String, num> mediaBuilder = new MapBuilder();
    mediaBuilder.updateValue('positive', (val) => (val + newMedia),
        ifAbsent: () => newMedia);
    movieBuilder.media = mediaBuilder;
    setCurrentMovie(movieBuilder.build());
  }

  void addCurrentMovieTagline(String tagline) {
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(currentMovie!);
    movieBuilder.tagline = tagline;
    setCurrentMovie(movieBuilder.build());
  }
}
