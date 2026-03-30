import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:media_gst/media_gst.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MediaGst.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _mediaGstPlugin = MediaGst();
  
  final GstPlayerController _playerController = GstPlayerController();
  final TextEditingController _uriController = TextEditingController(
    text: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
  );

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _playerController.dispose();
    _uriController.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _mediaGstPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _createAndPlay() async {
    await _playerController.initialize(_uriController.text);
    await _playerController.playStream();
  }

  Future<void> _stopPlayer() async {
    await _playerController.stopStream();
  }
  
  Future<void> _pausePlayer() async {
    await _playerController.pauseStream();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('MediaGst Player Widget Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion'),
              const SizedBox(height: 10),
              
              // 비디오 위젯 영역
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.hardEdge,
                child: GstPlayer(controller: _playerController),
              ),
              const SizedBox(height: 20),

              // 현재 상태 표시 영역
              ListenableBuilder(
                listenable: _playerController,
                builder: (context, _) {
                  return Text(
                    '상태: ${_playerController.state.name} | '
                    '버퍼링: ${_playerController.bufferingPercent}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _uriController,
                decoration: const InputDecoration(
                  labelText: 'Media URI (RTSP, HLS, MP4)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _createAndPlay,
                    child: const Text('초기화 & 재생'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _pausePlayer,
                    child: const Text('일시정지'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _stopPlayer,
                    child: const Text('정지'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
