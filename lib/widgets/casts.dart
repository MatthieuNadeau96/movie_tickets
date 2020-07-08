import 'package:flutter/material.dart';

import '../bloc/get_casts_bloc.dart';
import '../bloc/get_casts_bloc.dart';
import '../model/cast.dart';
import '../model/cast_response.dart';

class Casts extends StatefulWidget {
  final int id;
  Casts({Key key, @required this.id}) : super(key: key);
  @override
  _CastsState createState() => _CastsState(id);
}

class _CastsState extends State<Casts> {
  final int id;
  _CastsState(this.id);

  @override
  void initState() {
    super.initState();
    castsBloc..getCasts(id);
  }

  @override
  void dispose() {
    super.dispose();
    castsBloc..dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Actors',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 15),
        StreamBuilder<CastResponse>(
          stream: castsBloc.subject.stream,
          builder: (context, AsyncSnapshot<CastResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return _buildErrorWidget(snapshot.data.error);
              }
              return _buildCastsWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        ),
      ],
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

  Widget _buildCastsWidget(CastResponse data) {
    final Size size = MediaQuery.of(context).size;
    List<Cast> casts = data.casts;
    return Container(
      height: size.height * 0.22,
      child: ListView.builder(
        itemCount: casts.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(left: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w300/' + casts[index].img,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    casts[index].name,
                    maxLines: 2,
                    style: TextStyle(
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
