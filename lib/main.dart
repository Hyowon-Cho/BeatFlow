import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeatFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterSoundRecorder? _audioRecorder;
  FlutterSoundPlayer? _audioPlayer;
  bool _isRecording = false;
  bool _isPlaying = false;
  String _audioFilePath = 'audio_file.aac';
  bool _isSupported = !kIsWeb && !Platform.isWindows;

  @override
  void initState() {
    super.initState();
    if (_isSupported) {
      _audioRecorder = FlutterSoundRecorder();
      _audioPlayer = FlutterSoundPlayer();
      initAudio();
    }
  }

  Future<void> initAudio() async {
    if (_isSupported) {
      await _audioRecorder!.openRecorder();
      await _audioPlayer!.openPlayer();
    }
  }

  @override
  void dispose() {
    if (_isSupported) {
      _audioRecorder!.closeRecorder();
      _audioPlayer!.closePlayer();
    }
    super.dispose();
  }

  Future<void> startRecording() async {
    if (_isSupported) {
      await _audioRecorder!.startRecorder(toFile: _audioFilePath);
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> stopRecording() async {
    if (_isSupported) {
      await _audioRecorder!.stopRecorder();
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> startPlaying() async {
    if (_isSupported) {
      await _audioPlayer!.startPlayer(fromURI: _audioFilePath);
      setState(() {
        _isPlaying = true;
      });
    }
  }

  Future<void> stopPlaying() async {
    if (_isSupported) {
      await _audioPlayer!.stopPlayer();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BeatFlow Audio Recorder & Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isSupported) ...[
              ElevatedButton(
                onPressed: _isRecording ? stopRecording : startRecording,
                child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isPlaying ? stopPlaying : startPlaying,
                child: Text(_isPlaying ? 'Stop Playing' : 'Start Playing'),
              ),
            ] else
              const Text('Audio features are not supported on this platform'),
          ],
        ),
      ),
    );
  }
}