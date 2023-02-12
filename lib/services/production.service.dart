import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:api/api.dart';

class ProductionService {
  static final api = Api(
      dio: Dio(BaseOptions(
    baseUrl: 'http://localhost:3000',
    connectTimeout: 20000,
    receiveTimeout: 3000,
  ))).getDefaultApi();

  static Future<String> generatePoster(movie, useGpt) async {
    var builder = GeneratePosterRequestBuilder();
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(movie!);
    builder.movie = movieBuilder;
    builder.useGpt = useGpt;

    var image =
        await api.generatePoster(generatePosterRequest: builder.build());

    return image.data!.path;
  }

  static Future<Scandal> generateScandal(movie, useGpt) async {
    var builder = GeneratePosterRequestBuilder();
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(movie!);
    builder.movie = movieBuilder;
    builder.useGpt = true;

    var image =
        await api.generateScandal(generatePosterRequest: builder.build());

    return image.data!;
  }

  static Future<Issue> generateIssue(movie, useGpt) async {
    var builder = GenerateIssueRequestBuilder();
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(movie!);
    builder.movie = movieBuilder;
    builder.useGpt = true;

    var image = await api.generateIssue(generateIssueRequest: builder.build());

    return image.data!;
  }

  static Future<BuiltList<String>> generateTaglines(movie, useGpt) async {
    var builder = GeneratePosterRequestBuilder();
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(movie!);
    builder.movie = movieBuilder;
    builder.useGpt = true;

    var image =
        await api.generateTaglines(generatePosterRequest: builder.build());

    return image.data!;
  }

  static Future<String> generateJournalLine(movie, useGpt) async {
    var builder = GeneratePosterRequestBuilder();
    var movieBuilder = MovieBuilder();
    movieBuilder.replace(movie!);
    builder.movie = movieBuilder;
    builder.useGpt = true;

    var log =
        await api.generateProductionLog(generatePosterRequest: builder.build());
    return log.data!;
  }

  static num generateCost(Movie movie) {
    return (100 + Random().nextInt(400)) * 1000;
  }
}
