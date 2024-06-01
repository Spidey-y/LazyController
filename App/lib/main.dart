import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:remote/appbar.dart';
import 'package:remote/touchpad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LazyController',
      routes: {
        '/touchpad': (context) => const TouchPad(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    bool isHorizontal = orientation == Orientation.landscape;

    final List buttons = [
      {
        "title": "Play/Pause",
        "icon": Icons.play_circle_outlined,
        "iconColor": Colors.white,
        "color": Colors.blue,
        "url": "play_pause"
      },
      {
        "title": "Next",
        "icon": Icons.skip_next_outlined,
        "iconColor": Colors.white,
        "color": Colors.blue,
        "url": "next_track"
      },
      {
        "title": "Previous",
        "icon": Icons.skip_previous_outlined,
        "iconColor": Colors.white,
        "color": Colors.blue,
        "url": "previous_track"
      },
      {
        "title": "Volume Up",
        "icon": Icons.volume_up_outlined,
        "iconColor": Colors.white,
        "color": Colors.blue,
        "url": "volume_up"
      },
      {
        "title": "Volume Down",
        "icon": Icons.volume_down_outlined,
        "iconColor": Colors.white,
        "color": Colors.blue,
        "url": "volume_down"
      },
      {
        "title": "Mute/Unmute",
        "icon": Icons.volume_off_outlined,
        "iconColor": Colors.white,
        "color": Colors.blue,
        "url": "mute"
      },
    ];

    return Scaffold(
        appBar: buildAppBar(context),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isHorizontal
                ? MediaQuery.of(context).size.width ~/ 150
                : MediaQuery.of(context).size.width ~/ 100,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: buttons.length + 1,
          itemBuilder: (BuildContext context, int index) {
            return index < buttons.length
                ? gridButton(buttons[index]["title"], buttons[index]["icon"],
                    buttons[index]["iconColor"], buttons[index]["color"], () {
                    apiCall(buttons[index]["url"]);
                  })
                : gridButton(
                    "Touchpad", Icons.mouse_outlined, Colors.white, Colors.blue,
                    () {
                    Navigator.pushNamed(context, '/touchpad');
                  });
          },
        ));
  }

  String? hostname = html.window.location.hostname;
  int port = html.window.location.port == ""
      ? 80
      : int.parse(html.window.location.port) - 1;

  void apiCall(String endpoint) async {
    var url = Uri.http("$hostname:$port", endpoint);
    var response = await http.get(url);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
  }

  gridButton(
      String title, IconData icon, Color iconColor, Color color, action) {
    return InkWell(
      onTap: () {
        action();
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 45,
            ),
            FittedBox(
                child: Text(
              title,
              maxLines: 2,
              style: TextStyle(
                  color: iconColor, fontSize: 20, fontWeight: FontWeight.bold),
            ))
          ],
        ),
      ),
    );
  }
}
