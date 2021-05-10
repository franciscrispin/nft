import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Counter(),
        ),
      ),
    ),
  );
}

class Counter extends StatefulWidget {
  @override
  // When createState is called, a State object is created and is associated
  // with a BuildContext.
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  @override
  // The first method called when the widget is created.
  // initState is called once and only once.
  void initState() {
    super.initState();
    print('counter initState');
  }

  void _increment() {
    // Notifies the widget about state changes which causes the widget to
    // rebuild.
    setState(() {
      ++_counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('counter build');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CounterIncrementor(onPressed: _increment),
        SizedBox(width: 16),
        CounterDisplay(count: _counter),
      ],
    );
  }
}

class CounterIncrementor extends StatelessWidget {
  CounterIncrementor({required this.onPressed});

  final VoidCallback onPressed;

  // In a stateless widget, the build function only runs once.
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Increment'),
    );
  }
}

class CounterDisplay extends StatelessWidget {
  CounterDisplay({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}
