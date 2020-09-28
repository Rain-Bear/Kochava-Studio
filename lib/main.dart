import 'package:flutter/material.dart';
import 'package:kochava_studio/InfoDisplayCard.dart';
import 'package:kochava_studio/studio_extensions.dart';

void main() {
  runApp(KochavaStudio());
}

class KochavaStudio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kochava Studio',
      theme: ThemeData(
        primaryColor: kochavaBlack,
        accentColor: kochavaRed,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(title: 'Kochava Studio'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kochavaGrey,
        appBar: AppBar(
          title: Text('Kochava Studio'),
        ),
        body: Column(
          children: <Widget>[
            InfoDisplayCard(),
            SizedBox(height: 30),
          ],
        ));
  }
}
