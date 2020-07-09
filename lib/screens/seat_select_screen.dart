import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_tickets/bloc/get_movie_video_bloc.dart';
import 'package:movie_tickets/model/movie.dart';
import 'package:movie_tickets/model/video.dart';
import 'package:movie_tickets/model/video_response.dart';

class SeatSelectScreen extends StatefulWidget {
  final Movie movie;
  final int movieIndex;

  SeatSelectScreen({Key key, @required this.movie, this.movieIndex})
      : super(key: key);
  @override
  _SeatSelectScreenState createState() =>
      _SeatSelectScreenState(movie, movieIndex);
}

class _SeatSelectScreenState extends State<SeatSelectScreen> {
  final Movie movie;
  final int movieIndex;
  _SeatSelectScreenState(this.movie, this.movieIndex);

  @override
  void initState() {
    super.initState();
    movieVideoBloc..getMovieVideo(movie.id);
  }

  @override
  void dispose() {
    movieVideoBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return StreamBuilder<VideoResponse>(
            stream: movieVideoBloc.subject.stream,
            builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return _buildErrorWidget(snapshot.data.error);
                }
                return _buildSeatSelectorWidget(snapshot.data);
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error);
              } else {
                return _buildLoadingWidget();
              }
            },
          );
        },
      ),
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

  Widget _buildSeatSelectorWidget(VideoResponse data) {
    List<Video> videos = data.videos;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0, left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 180,
                color: Colors.grey[200],
              ),
              Container(
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 80,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                  ),
                  itemBuilder: (context, index) {
                    return IconButton(
                      icon: Icon(
                        Icons.weekend,
                        color: Colors.grey,
                      ),
                      onPressed: null,
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Available',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Taken',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Selected',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        DateFormat.MMMMd().format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: GestureDetector(
                              child: index == 0
                                  ? Container(
                                      width: 80,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.red[600],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '7:30',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[200],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 80,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          width: 0.5,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '7:30',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[200],
                                          ),
                                        ),
                                      ),
                                    ),
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: MaterialButton(
              colorBrightness: Brightness.dark,
              color: Colors.red[600],
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'PAY',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              onPressed: () {},
              // onPressed: () {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => SeatSelectScreen(movie: movie),
              //       ));
              // },
            ),
          ),
        ),
      ],
    );
  }
}
