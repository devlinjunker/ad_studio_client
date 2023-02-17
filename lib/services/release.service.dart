import 'dart:math';

import 'package:api/api.dart';

class ReleaseService {
  static Map<String, num> lastRevenue = {};

  // OTHER IDEAS:
  // Get Sales? return the number of people who watched? multiply this by ticket price based on era?
  // Get number of theaters?
  static num getRevenue(Movie movie) {
    num MAX = 3000000;
    num MIN = 1000000;

    // MAX affected by Media Rating
    // More media = higher MAX
    if (movie.media != null) {
      num pos = movie.media!.asMap()['positive'] ?? 1;
      num neg = movie.media!.asMap()['negative'] ?? 1;

      // more for mix of positive+negative
      num multiplier = pow(1.5, (pos + neg) - ((pos - neg).abs() / 2));

      MAX = MAX + (multiplier * 250000);
    }

    // start revenue at random between 1 mil and MAX
    var revenue = MIN + Random().nextInt((MAX - MIN).round());

    const ratingMatchValue = 0.3;

    num rating = 0;
    // Get Moving Rating (decimal value)
    // Actor Ratings + Movie Ratings
    rating = rating +
        getRatingMatch(
                movie.thrill, movie.actor!.thrill, movie.actress!.thrill) *
            (ratingMatchValue) +
        getRatingMatch(
                movie.action, movie.actor!.action, movie.actress!.action) *
            (ratingMatchValue) +
        getRatingMatch(movie.drama, movie.actor!.drama, movie.actress!.drama) *
            (ratingMatchValue) +
        getRatingMatch(
                movie.family, movie.actor!.family, movie.actress!.family) *
            (ratingMatchValue) +
        // getRatingMatch(
        //         movie.mystery, movie.actor!.mystery, movie.actress!.mystery) *
        (ratingMatchValue) +
        getRatingMatch(
                movie.romance, movie.actor!.romance, movie.actress!.romance) *
            (ratingMatchValue) +
        getRatingMatch(
                movie.comedy, movie.actor!.comedy, movie.actress!.comedy) *
            (ratingMatchValue);

    // multiply revenue by (1-rating) to reduce slightly
    revenue = revenue * (1 - rating);

    // Media adds slight bonus (multiply by 1.01 * media)
    // But Media reduces (1-2 per week) as weeks go by
    movie.media;

    // TODO: Seems like this should drop faster
    // Update Based on Week After Release (closer to release is better)
    // reduce by random 3-10% per week after release
    for (var week = 0; week < movie.releaseWeek; week++) {
      revenue = revenue * (1 - (0.03 + (Random().nextDouble() * 0.07)));
    }

    return revenue;
  }

  static num getRatingMatch(num movie, num actor, num actress) {
    var actorDiff = (movie - actor).abs() / 10;
    var actressDiff = (movie - actress).abs() / 10;

    // decimal value (hopefully between 0.01 and 0.4)
    return actorDiff * actressDiff;
  }
}
