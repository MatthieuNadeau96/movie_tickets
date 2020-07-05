import 'package:movie_tickets/model/movie_detail_response.dart';
import 'package:movie_tickets/model/video_response.dart';
import 'package:movie_tickets/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieVideoBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<VideoResponse> _subject =
      BehaviorSubject<VideoResponse>();

  getMovieVideo(int id) async {
    VideoResponse response = await _repository.getMovieVideo(id);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<VideoResponse> get subject => _subject;
}

final movieVideoBloc = MovieVideoBloc();
