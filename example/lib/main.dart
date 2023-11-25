import 'package:flexible_segmented_button/flexible_segmented_button.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int _activeIndex = 3;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: FlexibleSegmentedButton(
          activeIndex: _activeIndex,
          onSegmentTap: (index) {
            setState(() {
              _activeIndex = index;
            });
          },
          segments: const <FlexibleSegment<int>>[
            FlexibleSegment(
              top: Text('Week 1'),
              center: Text('1'),
              bottom: Text('Text'),
            ),
            FlexibleSegment(
              top: Text('Week 1'),
              center: Text('2'),
              bottom: Text('Text'),
            ),
            FlexibleSegment(
              top: Text('Week 1'),
              center: Text('3'),
              bottom: Text('Text'),
            ),
            FlexibleSegment(
              top: Text('Week 1'),
              center: Text('4'),
              bottom: Text('Text'),
            ),
            FlexibleSegment(
              top: Text('Week 1'),
              center: Text('5'),
              bottom: Text('Text'),
            ),
            FlexibleSegment(
              top: Text('Week 1'),
              center: Text('6'),
              bottom: Text('Text'),
            ),
            FlexibleSegment(
              top: Text('Week 1'),
              center: Text('7'),
              bottom: Text('Text'),
            ),

          ],
        ),
      ),
    );
  }
}
