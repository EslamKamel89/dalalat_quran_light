import 'package:audioplayers/audioplayers.dart';
import 'package:dalalat_quran_light/ui/intro_screen.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RadioScreen extends StatefulWidget {
  static String id = '/RadioScreen';
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray,
      appBar: QuranBar(
        'audio_recitations'.tr,
        backCallback: () {
          Get.offNamedUntil(IntroScreen.id, (_) => false);
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: const StreamAudioPlayer(
          url: 'https://listen.radioking.com/radio/810226/stream/879041',
        ),
      ),
    );
  }
}

class StreamAudioPlayer extends StatefulWidget {
  final String url;

  const StreamAudioPlayer({super.key, required this.url});

  @override
  State<StreamAudioPlayer> createState() => _StreamAudioPlayerState();
}

class _StreamAudioPlayerState extends State<StreamAudioPlayer> with SingleTickerProviderStateMixin {
  late final AudioPlayer _player;
  late final AnimationController _waveController;

  PlayerState _playerState = PlayerState.stopped;
  bool _isLoading = false;

  bool get _isPlaying => _playerState == PlayerState.playing;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();
    _waveController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);

    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _playerState = state;
        if (state == PlayerState.playing) {
          _isLoading = false;
        }
      });
    });
  }

  Future<void> _play() async {
    try {
      setState(() => _isLoading = true);
      await _player.play(UrlSource(widget.url));
    } catch (e) {
      debugPrint('Audio play error: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pause() async {
    await _player.pause();
  }

  Future<void> _stop() async {
    await _player.stop();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(1000),
            topRight: Radius.circular(1000),
          ),
          boxShadow: [
            BoxShadow(
              color: mediumGray.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _WaveIndicator(controller: _waveController, active: _isPlaying),
            const SizedBox(height: 16),
            Text(
              'بث مباشرة',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              _isLoading
                  ? 'جاري التحميل...'
                  : _isPlaying
                  ? 'يتم التشغيل الآن'
                  : 'متوقف مؤقتًا',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 22),
            Center(child: Image.asset(soundMedium, height: 300)),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SecondaryButton(icon: Icons.stop_rounded, onTap: _stop),
                const SizedBox(width: 24),
                _PrimaryButton(
                  isPlaying: _isPlaying,
                  isLoading: _isLoading,
                  onTap: () {
                    if (_isPlaying) {
                      _pause();
                    } else {
                      _play();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onTap;

  const _PrimaryButton({required this.isPlaying, required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [primaryColor, primaryColor2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 36,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SecondaryButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

class _WaveIndicator extends StatelessWidget {
  final AnimationController controller;
  final bool active;

  const _WaveIndicator({required this.controller, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final scale = active ? 1 + controller.value * 0.25 : 1.0;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? Colors.green : mediumGray,
            ),
          ),
        );
      },
    );
  }
}
