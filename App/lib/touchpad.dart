import 'dart:async';

import 'package:flutter/material.dart';
import 'package:remote/appbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class TouchPad extends StatefulWidget {
  const TouchPad({Key? key}) : super(key: key);

  @override
  State<TouchPad> createState() => _TouchPadState();
}

class _TouchPadState extends State<TouchPad> {
  late WebSocketChannel _channel;
  String? hostname = html.window.location.hostname;
  int port = html.window.location.port == ""
      ? 80
      : int.parse(html.window.location.port) - 1;

  Timer? _sendTimer;
  Offset _lastSentPoint = Offset.zero;

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(Uri.parse('ws://$hostname:$port/move'));
  }

  @override
  void dispose() {
    _channel.sink.close();
    _sendTimer?.cancel(); // Cancel the timer when disposing the widget
    super.dispose();
  }

  void _sendMove(double x, double y) {
    _channel.sink.add('{"x": $x, "y": $y}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: GestureDetector(
        onPanStart: (details) {
          _lastSentPoint = details.localPosition;
          _startSendingTimer();
        },
        onPanUpdate: (details) {
          _lastSentPoint = details.localPosition;
        },
        onPanEnd: (_) {
          _stopSendingTimer();
        },
        onTap: () => print('Click'),
        onLongPress: () => print('Right Click'),
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Text(
              'TouchPad\n- Swipe to move cursor\n- Tap to click\n- Scroll to scroll\n- Long press to right click',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startSendingTimer() {
    _sendTimer ??= Timer.periodic(const Duration(milliseconds: 50), (_) {
      double x = _lastSentPoint.dx / MediaQuery.of(context).size.width;
      double y = _lastSentPoint.dy / MediaQuery.of(context).size.height;
      _sendMove(x, y);
    });
  }

  void _stopSendingTimer() {
    _sendTimer?.cancel();
    _sendTimer = null;
  }
}
