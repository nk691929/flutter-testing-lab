import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const new({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: Center(child: Text('Count: $_count')),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => setState(() {
              _count++;
            }),
            tooltip: 'increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: 'remove',
            onPressed: () => setState(() {
              _count--;
            }),
            tooltip: 'decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
