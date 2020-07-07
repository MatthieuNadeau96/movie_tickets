import 'package:movie_tickets/model/genre.dart';

class MovieDetail {
  final int id;
  final bool adult;
  final int budget;
  final String title;
  final String backPoster;
  final String poster;
  final String overview;
  final List<Genre> genres;
  final String releaseDate;
  final int runTime;
  final double rating;

  MovieDetail(
    this.id,
    this.adult,
    this.budget,
    this.title,
    this.backPoster,
    this.poster,
    this.overview,
    this.genres,
    this.releaseDate,
    this.runTime,
    this.rating,
  );

  MovieDetail.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        adult = json['adult'],
        budget = json['budget'],
        title = json['title'],
        backPoster = json['backdrop_path'],
        poster = json['poster_path'],
        overview = json['overview'],
        genres =
            (json['genres'] as List).map((i) => new Genre.fromJson(i)).toList(),
        releaseDate = json['release_date'],
        runTime = json['runtime'],
        rating = json['vote_average'].toDouble();
}
