import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_tickets/bloc/get_now_playing_movies_bloc.dart';
import 'package:movie_tickets/model/movie.dart';
import 'package:movie_tickets/model/movie_response.dart';

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  CarouselController carouselLinkController = CarouselController();

  int prevIndex = -1;

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
          return _buildNowPlayingWidget(snapshot.data);
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

  Widget _buildNowPlayingWidget(MovieResponse data) {
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
        body: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                reverse: true,
                height: size.height,
                viewportFraction: 1,
              ),
              carouselController: carouselLinkController,
              items: movies.sublist(0, 10).map((movie) {
                return Builder(
                  builder: (BuildContext context) {
                    return Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: size.width,
                            // margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://image.tmdb.org/t/p/original/' +
                                      movie.backPoster,
                                ),
                                fit: BoxFit.cover,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ///
                ///
                //////////////////////////////////////////.//////////////////////////////////////////////////
                ///
                ///

                CarouselSlider(
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      _linkHandler(index);
                      setState(() {
                        prevIndex = index;
                      });
                    },
                    height: size.height * 0.75,
                    enlargeCenterPage: true,
                  ),
                  items: movies.sublist(0, 10).map((movie) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          padding: EdgeInsets.only(
                            bottom: 30,
                            left: 30,
                            right: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Image container
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 30,
                                  ),
                                  width: size.width,
                                  // margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
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
                              Text(
                                movie.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    movie.rating.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  RatingBar(
                                    itemSize: 15,
                                    initialRating: movie.rating / 2,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 2),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.yellow[800],
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                ],
                              ),
                              // SizedBox(height: 5),
                              IconButton(
                                icon: Icon(
                                  Icons.more_horiz,
                                  color: Colors.grey[700],
                                ),
                                onPressed: () {},
                              ),
                              SizedBox(height: 5),
                              MaterialButton(
                                colorBrightness: Brightness.dark,
                                color: Colors.grey[900],
                                minWidth: size.width,
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  'BUY TICKET',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      );
  }

  dynamic _linkHandler(int index) {
    print('prevIndex = $prevIndex');
    print('index = $index');
    if (prevIndex > index) {
      if (prevIndex == 9 && index == 0) {
        return carouselLinkController.nextPage(
          duration: Duration(milliseconds: 400),
          curve: Curves.linear,
        );
      }
      return carouselLinkController.previousPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
    } else if (prevIndex < index) {
      if ((prevIndex == 0 || prevIndex == -1) && index == 9) {
        return carouselLinkController.previousPage(
          duration: Duration(milliseconds: 400),
          curve: Curves.linear,
        );
      }
      return carouselLinkController.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
    }
  }
}
