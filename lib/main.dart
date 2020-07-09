import 'package:flutter/material.dart';
import 'package:movie_tickets/screens/seat_select_screen.dart';
import 'package:movie_tickets/screens/selection_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SelectionScreen(),
    );
  }
}
