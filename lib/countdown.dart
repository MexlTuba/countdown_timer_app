// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:async';

class _PomodoroTimerState extends State<PomodoroTimer> {
  Timer? _timer;
  Duration _workDuration = Duration(minutes: 25);
  Duration _shortBreakDuration = Duration(minutes: 5);
  Duration _longBreakDuration = Duration(minutes: 15);
  Duration _currentDuration = Duration(minutes: 25);
  int _workIntervalCount = 0;
  bool _isWorkInterval = true;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _currentDuration = _workDuration;
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _workIntervalCount = 0;
      _isWorkInterval = true;
      _currentDuration = _workDuration;
    });
  }

  void _updateTimer() {
    setState(() {
      final seconds = _currentDuration.inSeconds - 1;
      if (seconds < 0) {
        _timer?.cancel();
        _isRunning = false;
        _switchInterval();
      } else {
        _currentDuration = Duration(seconds: seconds);
      }
    });
  }

  void _switchInterval() {
    setState(() {
      _workIntervalCount += _isWorkInterval ? 1 : 0;
      _isWorkInterval = !_isWorkInterval;
      _currentDuration = _isWorkInterval
          ? _workDuration
          : (_workIntervalCount % 4 == 0
              ? _longBreakDuration
              : _shortBreakDuration);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    Color? backgroundColor =
        _isWorkInterval ? Colors.red[400] : Colors.green[400];
    if (!_isWorkInterval && _workIntervalCount % 4 == 0) {
      backgroundColor = Colors.blue[400];
    }

    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(_currentDuration.inHours.remainder(24));
    final minutes = strDigits(_currentDuration.inMinutes.remainder(60));
    final seconds = strDigits(_currentDuration.inSeconds.remainder(60));

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: Text(
            'POMODORO TIMER',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _isWorkInterval ? 'Work' : 'Break',
                    style: themeData.textTheme.headlineMedium,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$hours:$minutes:$seconds',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: backgroundColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Work Duration:',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                _durationPicker(_workDuration, (newDuration) {
                  setState(() => _workDuration = newDuration);
                }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Short Break Duration:',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                _durationPicker(_shortBreakDuration, (newDuration) {
                  setState(() => _shortBreakDuration = newDuration);
                }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Long Break Duration:',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                _durationPicker(_longBreakDuration, (newDuration) {
                  setState(() => _longBreakDuration = newDuration);
                }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  child: Text('Start'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: backgroundColor,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isRunning ? _stopTimer : null,
                  child: Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: backgroundColor,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isRunning ? null : _resetTimer,
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: backgroundColor,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Completed Work Intervals: $_workIntervalCount'),
          ],
        ),
      ),
    );
  }
}

Widget _durationPicker(Duration duration, ValueChanged<Duration> onChanged) {
  return Row(
    children: [
      IconButton(
        icon: Icon(Icons.remove_circle),
        onPressed: () {
          final newDuration = Duration(minutes: duration.inMinutes - 1);
          if (newDuration.inMinutes >= 1) onChanged(newDuration);
        },
      ),
      Text(
        '${duration.inMinutes} min',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      IconButton(
        icon: Icon(Icons.add_circle),
        onPressed: () {
          final newDuration = Duration(minutes: duration.inMinutes + 1);
          onChanged(newDuration);
        },
      ),
    ],
  );
}

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}
