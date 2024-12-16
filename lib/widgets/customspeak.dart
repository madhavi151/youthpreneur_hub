import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class tts extends StatefulWidget {
  @override
  _ttsState createState() => _ttsState();
}

class _ttsState extends State<tts> {
  late FlutterTts flutterTts;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  String? _newVoiceText;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _setAwaitOptions();
  }

  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  // Custom method to handle speaking the text
  Future<void> customSpeak(String text) async {
    await flutterTts.setVolume(volume); // Set volume
    await flutterTts.setSpeechRate(rate); // Set speech rate
    await flutterTts.setPitch(pitch); // Set pitch

    if (text.isNotEmpty) {
      await flutterTts.speak(text); // Speak the passed text
    }
  }

  Widget _btnSection() {
    return Container(
      padding: EdgeInsets.only(top: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(
              Colors.green,
              Colors.greenAccent,
              Icons.play_arrow,
              'PLAY',
                  () {
                if (_newVoiceText != null && _newVoiceText!.isNotEmpty) {
                  customSpeak(_newVoiceText!); // Pass the entered text to the custom speak method
                } else {
                  print("No text entered to speak.");
                }
              }
          ),
          _buildButtonColumn(
              Colors.red,
              Colors.redAccent,
              Icons.stop,
              'STOP',
                  () {
                flutterTts.stop();
              }),
          _buildButtonColumn(
              Colors.blue,
              Colors.blueAccent,
              Icons.pause,
              'PAUSE',
                  () {
                flutterTts.pause();
              }),
        ],
      ),
    );
  }

  Column _buildButtonColumn(Color color, Color splashColor, IconData icon, String label, Function func) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(icon),
              color: color,
              splashColor: splashColor,
              onPressed: () => func()),
          Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: color)))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter TTS'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _inputSection(),
              _btnSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputSection() => Container(
    alignment: Alignment.topCenter,
    padding: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
    child: TextField(
      maxLines: 11,
      minLines: 6,
      onChanged: (String value) {
        setState(() {
          _newVoiceText = value; // Update _newVoiceText when text is changed
        });
      },
    ),
  );
}