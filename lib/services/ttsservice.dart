// tts_service.dart

import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts flutterTts = FlutterTts();

  static double volume = 0.5;
  static double pitch = 1.0;
  static double rate = 0.5;

  // Initialize TTS and configure it
  static Future<void> init() async {
    await flutterTts.awaitSpeakCompletion(true); // Set await completion
    // You can set the default configurations here
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
  }

  // Global method to speak text
  static Future<void> customSpeak(String text) async {
    if (text.isNotEmpty) {
      await flutterTts.speak(text); // Speak the text
    }
  }

  // You can add more helper methods here (e.g., stop, pause, etc.)
  static Future<void> stop() async {
    await flutterTts.stop();
  }

  static Future<void> pause() async {
    await flutterTts.pause();
  }

  // static Future<void> continueSpeaking() async {
  //   await flutterTts.resume();
  // }
}
