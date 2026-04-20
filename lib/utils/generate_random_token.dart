import 'dart:math';

final Random _random = Random.secure();
const String _chars =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    'abcdefghijklmnopqrstuvwxyz'
    '0123456789';

String generateRandom16CharId() {
  return List.generate(16, (_) {
    final index = _random.nextInt(_chars.length);
    return _chars[index];
  }).join();
}
