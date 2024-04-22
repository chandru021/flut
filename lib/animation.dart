import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LineByLineTextAnimation extends StatelessWidget {
  // final String text;
  final Map<String, dynamic> data;

  LineByLineTextAnimation({required this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Area Report'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Expanded(
                flex: 4, // Adjust the flex value for the image
                child: SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: this.data["urls"].map<Widget>((url) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(url),
        ),
      );
    }).toList(),
  ),
),
              ),
              Expanded(
                flex: 5, // Adjust the flex value for the text
                child: SingleChildScrollView(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        this.data["message"],
                        textAlign: TextAlign.left,
                        textStyle: TextStyle(fontSize: 18.0),
                        speed: Duration(milliseconds: 30),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: Duration(milliseconds: 1000),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}