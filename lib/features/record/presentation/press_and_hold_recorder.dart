import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:dalalat_quran_light/env.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

final Dio _dio = Dio(
  BaseOptions(
    baseUrl: 'https://api.deepinfra.com/v1',
    headers: {'Authorization': 'Bearer ${Env.DEEP_INFRA_API_KEY}'},
  ),
);

class PressAndHoldRecorder extends StatefulWidget {
  const PressAndHoldRecorder({super.key, required this.onTranscriptReady});
  final ValueChanged<String> onTranscriptReady;

  @override
  State<PressAndHoldRecorder> createState() => _PressAndHoldRecorderState();
}

class _PressAndHoldRecorderState extends State<PressAndHoldRecorder> {
  late final AudioRecorder _recorder;
  late final AudioPlayer _audioPlayer;
  bool _isLoading = false;
  bool _isRecording = false;
  Timer? _timer;
  Duration _recordDuration = Duration(seconds: 0);
  @override
  void initState() {
    super.initState();
    _recorder = AudioRecorder();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _recorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (_isRecording) return;
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _recordDuration += const Duration(seconds: 1);
      });
    });
    final directory = Directory.systemTemp;
    final filePath = '${directory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    const config = RecordConfig(encoder: AudioEncoder.aacLc, sampleRate: 16000, bitRate: 64000);
    await _recorder.start(config, path: filePath);
    setState(() {
      _isRecording = true;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _recordDuration = Duration.zero;
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
    final path = await _recorder.stop();
    _stopTimer();
    setState(() {
      _isRecording = false;
      _isLoading = true;
    });
    pr(path, 'file path');
    // await _playRecordedAudio(path);
    // return;
    final transcript = await _uploadAndTranscribe(path);
    setState(() {
      _isLoading = false;
    });
    if (transcript != null && transcript.isNotEmpty) {
      widget.onTranscriptReady(transcript);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isRecording) {
          _stopRecording();
        } else {
          _startRecording();
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (_isRecording) _buildTimer(),
          Builder(
            builder: (context) {
              final child = Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.red : primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isRecording ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 30,
                ),
              );
              if (_isLoading) {
                // return child.animate(onPlay: (c) => c.repeat()).shimmer(duration: 1000.ms);
                return Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(10),

                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              return child;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    final minutes = _recordDuration.inMinutes.toString().padLeft(2, '0');
    final seconds = (_recordDuration.inSeconds % 60).toString().padLeft(2, '0');
    return Positioned(
      top: -20,
      child: Text(
        '$minutes:$seconds',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<String?> _uploadAndTranscribe(String? filePath) async {
    if (filePath == null) return null;
    final file = File(filePath);
    if (!await file.exists()) return null;
    final formData = FormData.fromMap({
      'audio': await MultipartFile.fromFile(file.path, filename: file.uri.pathSegments.last),
      'task': 'transcribe',
      'language': 'ar',
    });
    final response = await _dio.post('/inference/openai/whisper-large-v3', data: formData);
    final data = response.data;
    pr(data, '_uploadAndTranscribe');
    if (data is Map && data['text'] is String) {
      return pr(data['text'] as String, '_uploadAndTranscribe');
    }
    return null;
  }

  Future<void> _playRecordedAudio(String? filePath) async {
    if (filePath == null) return;
    final file = File(filePath);
    if (!await file.exists()) return;
    await _audioPlayer.stop();

    await _audioPlayer.play(DeviceFileSource(file.path));
  }
}
