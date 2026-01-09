import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:system_alert_window/system_alert_window.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhisperFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TranslatorHomePage(),
    );
  }
}

class TranslatorHomePage extends StatefulWidget {
  const TranslatorHomePage({super.key});

  @override
  State<TranslatorHomePage> createState() => _TranslatorHomePageState();
}

class _TranslatorHomePageState extends State<TranslatorHomePage> {
  late final AudioRecorder _audioRecorder;
  bool _isRecording = false;
  String _displayText = '点击下方按钮开始实时抓取翻译';

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _requestOverlayPermissions();
    // SystemAlertWindow.registerOnClickListener(_overlayEntryPoint);
  }

  // Must be static or top-level
  /*
  @pragma('vm:entry-point')
  static void _overlayEntryPoint(SystemWindowPrefetchArgument? argument) {
    if (argument?.tag == "close_button") {
      SystemAlertWindow.closeSystemWindow(prefMode: SystemWindowPrefMode.OVERLAY);
    }
  }
  */

  Future<void> _requestOverlayPermissions() async {
    await SystemAlertWindow.requestPermissions(prefMode: SystemWindowPrefMode.OVERLAY);
  }

  void _showOverlay() {
    SystemAlertWindow.showSystemWindow(
      height: 100,
      gravity: SystemWindowGravity.BOTTOM,
      prefMode: SystemWindowPrefMode.OVERLAY,
      /* 
      // Temporary commented out due to analysis issues with package version
      header: SystemWindowHeader(
        subTitle: SystemWindowText(
          text: "WhisperFlow Captions",
          fontSize: 10,
          textColor: Colors.white,
        ),
      ),
      body: SystemWindowBody(
        rows: [
          EachRow(
            columns: [
              EachColumn(
                text: SystemWindowText(
                  text: "正在监听...",
                  fontSize: 16,
                  textColor: Colors.white,
                ),
              ),
            ],
            gravity: ContentGravity.CENTER,
          ),
        ],
      ),
      */
    );
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    try {
      if (_isRecording) {
        final path = await _audioRecorder.stop();
        setState(() {
          _isRecording = false;
          _displayText = path != null ? '录制到的文件路径:\n$path' : '录制失败或未保存';
        });
      } else {
        if (await _audioRecorder.hasPermission()) {
          final directory = await getTemporaryDirectory();
          final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

          await _audioRecorder.start(const RecordConfig(), path: path);
          
          setState(() {
            _isRecording = true;
            _displayText = '正在监听音频...';
          });
        } else {
          setState(() {
            _displayText = '需要麦克风权限才能录音';
          });
        }
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
        _displayText = '发生错误: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhisperFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_in_picture),
            tooltip: '开启悬浮字幕',
            onPressed: _showOverlay,
          ),
        ],
      ),
      body: Center(
        child: Card(
          color: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          elevation: 8.0,
          child: Container(
            width: double.infinity,
            height: 500,
            padding: const EdgeInsets.all(32.0),
            alignment: Alignment.center,
            child: Text(
              _displayText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.large(
        onPressed: _toggleRecording,
        tooltip: _isRecording ? '停止' : '开始',
        child: Icon(_isRecording ? Icons.stop : Icons.mic),
      ),
    );
  }
}
