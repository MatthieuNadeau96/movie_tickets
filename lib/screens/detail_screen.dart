import 'package:flutter/material.dart';
import 'package:movie_tickets/model/movie.dart';
import 'package:movie_tickets/model/movie_response.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  DetailScreen({Key key, @required this.movie}) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState(movie);
}

class _DetailScreenState extends State<DetailScreen> {
  final Movie movie;
  _DetailScreenState(this.movie);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
