import 'package:flutter/material.dart';
import 'dart:async';

// class CountdownTimer extends StatefulWidget {
//   final int timeLimit;
//   final Function event;

//   CountdownTimer({required this.timeLimit, required this.event});

//   @override
//   _CountdownTimerState createState() => _CountdownTimerState();
// }

// class _CountdownTimerState extends State<CountdownTimer> {
//   Duration _duration = Duration(minutes: widget.timeLimit);
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }

//   void startTimer() {
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(oneSec, (timer) {
//       setState(() {
//         if (_duration.inSeconds == 0) {
//           _timer.cancel();
//         } else {
//           _duration = _duration - oneSec;
//         }
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     int minutes = _duration.inMinutes;
//     int seconds = _duration.inSeconds % 60;

//     return Center(
//       child: Text(
//         '$minutes:${seconds.toString().padLeft(2, '0')}',
//         style: const TextStyle(fontSize: 20),
//       ),
//     );
//   }
// }

class CountdownTimer extends StatefulWidget {
  final int timeLimit;
  final VoidCallback event;

  CountdownTimer({required this.timeLimit, required this.event});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _duration;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _duration =
        Duration(minutes: widget.timeLimit);
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_duration.inSeconds == 0) {
          _timer.cancel();
          widget.event();
        } else {
          _duration = _duration - oneSec;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _duration.inMinutes;
    int seconds = _duration.inSeconds % 60;

    return Center(
      child: Text(
        '$minutes:${seconds.toString().padLeft(2, '0')}',
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
