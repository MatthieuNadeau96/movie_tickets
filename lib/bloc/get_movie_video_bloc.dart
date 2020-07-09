import 'package:flutter/cupertino.dart';
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

  void drainStream() {
    _subject.value = null;
  }

  @mustCallSuper
  dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<VideoResponse> get subject => _subject;
}

final movieVideoBloc = MovieVideoBloc();
