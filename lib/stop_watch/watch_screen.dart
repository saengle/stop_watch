import 'dart:async';

import 'package:flutter/material.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({Key? key}) : super(key: key);

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  Timer? _timer;
  int _time = 0;
  bool _isRunning = false;
  List<String> _laptime = [];

  void _clickStartPauseButton() {
    _isRunning = !_isRunning;
    if (_isRunning) {
      _start();
    } else {
      _stop();
    }
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
      });
    });
  }

  void _stop() {
    setState(() {
      _timer?.cancel();
    });
  }

  void _reset() {
    _time = 0;
    _laptime = [];
    _timer?.cancel();
  }

  void _addLapTime() {
    _laptime.add('${_time ~/ 100}.${(_time % 100).toString().padLeft(2, '0')}');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int sec = _time ~/ 100;
    String hundredth = '${_time % 100}'.padLeft(2, '0');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Stop Watch'),
        ),
        body: Column(
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$sec',
                  style: const TextStyle(fontSize: 50),
                ),
                Text(
                  hundredth,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 300,
              width: 100,
              child: listViewBuilder(),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    if (_isRunning) {
                      setState(() {
                        _reset();
                        _clickStartPauseButton();
                      });
                    } else {
                      setState(() {
                        _reset();
                      });
                    }
                  },
                ),
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  child: _isRunning
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                  onPressed: () {
                    setState(() {
                      _clickStartPauseButton();
                    });
                  },
                ),
                FloatingActionButton(
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.add),
                  onPressed: () {
                    if (_isRunning) {
                      setState(() {
                        _addLapTime();
                      });
                    }
                  },
                ),
              ],
            ),
            const Spacer(),
          ],
        ));
  }

  Widget listViewBuilder() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _laptime.length,
      itemBuilder: (BuildContext context, int index) {
        return Center(child: Text(_laptime[index]));
      },
    );
  }
}
