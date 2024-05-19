import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:weather_ui/screens/search_city.dart';
import 'package:weather_ui/screens/steps_history.dart';

class StepCounter extends StatefulWidget {
  const StepCounter({super.key, this.title});

  final String? title;

  @override
  State<StepCounter> createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
  static const Duration _ignoreDuration = Duration(milliseconds: 20);

  UserAccelerometerEvent? _userAccelerometerEvent;

  DateTime? _userAccelerometerUpdateTime;

  int? _userAccelerometerLastInterval;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Duration sensorInterval = SensorInterval.normalInterval;
  double previousMagnitude = 0;
  int stepCount = 0;
  List<int> stepHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Step Counter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchCity(),
              ),
            );
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _showHistory,
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveSteps,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.withOpacity(0.1),
              Colors.red.shade400,
              Colors.red.withOpacity(0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Step Count:',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    stepCount.toString(),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(4),
                  4: FlexColumnWidth(1.6),
                },
                children: [
                  const TableRow(
                    children: [
                      SizedBox(),
                      Text(
                        'X',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Y',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Z',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Interval',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 50,
                        ),
                        child: Text(
                          'Accelerometer:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        _userAccelerometerEvent?.x.toStringAsFixed(1) ?? '0',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _userAccelerometerEvent?.y.toStringAsFixed(1) ?? '0',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _userAccelerometerEvent?.z.toStringAsFixed(1) ?? '0',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${_userAccelerometerLastInterval?.toString() ?? '0'} ms',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          final now = DateTime.now();
          setState(() {
            _userAccelerometerEvent = event;
            if (_userAccelerometerUpdateTime != null) {
              final interval = now.difference(_userAccelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _userAccelerometerLastInterval = interval.inMilliseconds;
              }
            }
            detectStep(event);
          });
          _userAccelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                    "It seems that your device doesn't support User Accelerometer Sensor"),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
  }

  void detectStep(UserAccelerometerEvent event) {
    if (_userAccelerometerEvent != null) {
      final double deltaX = (_userAccelerometerEvent!.x).abs();
      final double deltaY = (_userAccelerometerEvent!.y).abs();
      final double deltaZ = (_userAccelerometerEvent!.z).abs();

      final double magnitude =
          sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ);
      final double totalDelta = (magnitude - previousMagnitude).abs();
      previousMagnitude = magnitude;
      if (totalDelta > 6) {
        setState(() {
          stepCount++;
        });
      }
    }

    _userAccelerometerEvent = event;
  }

  void _saveSteps() {
    setState(() {
      stepHistory.insert(0, stepCount);
      stepCount = 0; 
    });
  }

  void _showHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepHistoryScreen(
          stepHistory: stepHistory,
          onDelete: _deleteHistoryItem,
        ),
      ),
    );
  }

  void _deleteHistoryItem(int index) {
    setState(() {
      stepHistory.removeAt(index);
    });
  }
}
