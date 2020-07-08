import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_tickets/bloc/get_now_playing_movies_bloc.dart';
import 'package:movie_tickets/model/movie.dart';
import 'package:movie_tickets/model/movie_response.dart';

class DetailPageCarousel extends StatefulWidget {
  final int movieIndex;

  DetailPageCarousel({Key key, this.movieIndex}) : super(key: key);
  @override
  _DetailPageCarouselState createState() =>
      _DetailPageCarouselState(movieIndex);
}

class _DetailPageCarouselState extends State<DetailPageCarousel> {
  final int movieIndex;
  _DetailPageCarouselState(this.movieIndex);

  @override
  void initState() {
    super.initState();

    nowPlayingMoviesBloc..getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: nowPlayingMoviesBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _buildErrorWidget(snapshot.data.error);
          }
          return _buildDetailCarouselWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Error occured: $error')],
      ),
    );
  }

  Widget _buildDetailCarouselWidget(MovieResponse data) {
    final Size size = MediaQuery.of(context).size;
    List<Movie> movies = data.movies;

    if (movies.length == 0) {
      return Container(
        child: Center(
          child: Text('No Movies'),
        ),
      );
    } else
      return Scaffold(
        backgroundColor: Colors.black,
        body: CarouselSlider(
          options: CarouselOptions(
            initialPage: movieIndex,
            height: size.height * 0.5,
            enlargeCenterPage: true,
          ),
          items: movies.sublist(0, 10).map((movie) {
            return Builder(
              builder: (BuildContext context) {
                return Column(
                  children: [
                    Expanded(
                      child: Hero(
                        tag: '${movie.id}',
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://image.tmdb.org/t/p/original/' +
                                    movie.poster,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }).toList(),
        ),
      );
  }
}
