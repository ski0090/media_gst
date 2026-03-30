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
  final List<String> _playerLogs = [];
  final ScrollController _logScrollController = ScrollController();
  final _mediaGstPlugin = MediaGst();
  
  PlayerInstance? _player;
  StreamSubscription<PlayerEvent>? _eventSubscription;
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
    _eventSubscription?.cancel();
    _player?.dispose();
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

  void _addLog(String msg) {
    if (!mounted) return;
    setState(() {
      final time = DateTime.now().toIso8601String().split('T')[1].substring(0, 8);
      _playerLogs.add('[$time] $msg');
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_logScrollController.hasClients) {
        _logScrollController.animateTo(
          _logScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _createAndPlay() async {
    try {
      // 1. 플레이어 생성
      final player = await createPlayer();
      setState(() {
        _player?.dispose();
        _player = player;
      });
      _addLog('Created');

      // 2. 이벤트 구독 (상태 변경, 버퍼링 등)
      _eventSubscription?.cancel();
      _eventSubscription = subscribePlayerEvents(player: player).listen((event) {
        if (!mounted) return;
        event.when(
          stateChanged: (state) => _addLog('State: ${state.name}'),
          error: (err) => _addLog('Error: $err'),
          endOfStream: () => _addLog('EOS (End of Stream)'),
          buffering: (percent) => _addLog('Buffering: $percent%'),
          clockLost: () => _addLog('Clock Lost'),
        );
      });

      // 3. 소스 URI 설정
      _addLog('Setting Source...');
      await setSource(player: player, uri: _uriController.text);

      // 4. 재생 시작
      _addLog('Playing...');
      await play(player: player);

    } catch (e) {
      if (mounted) {
        _addLog('Exception: $e');
      }
    }
  }

  Future<void> _stopPlayer() async {
    if (_player != null) {
      try {
        await stop(player: _player!);
      } catch (e) {
        debugPrint('Failed to stop: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('MediaGst Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion'),
              const SizedBox(height: 20),
              TextField(
                controller: _uriController,
                decoration: const InputDecoration(
                  labelText: 'Media URI (RTSP, HLS, MP4)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  width: double.infinity,
                  child: ListView.builder(
                    controller: _logScrollController,
                    itemCount: _playerLogs.length,
                    itemBuilder: (context, index) {
                      return Text(
                        _playerLogs[index],
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _createAndPlay,
                    child: const Text('Play URI'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _stopPlayer,
                    child: const Text('Stop'),
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
