import 'package:audioplayers/audioplayers.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:flutter/foundation.dart';

/// Phase-synced brew sounds (web + mobile). Browsers may require a user gesture
/// before the first play; starting brew from a button satisfies that.
class BrewAudioService {
  BrewAudioService() : _player = AudioPlayer();

  final AudioPlayer _player;
  CoffeeMachinePhase? _lastPhase;
  bool _muted = false;

  bool get muted => _muted;

  void toggleMute() => _muted = !_muted;

  Future<void> onPhaseChanged(CoffeeMachinePhase phase) async {
    if (phase == _lastPhase) return;
    _lastPhase = phase;
    if (_muted || phase == CoffeeMachinePhase.idle) {
      await _player.stop();
      return;
    }

    final spec = _soundFor(phase);
    if (spec == null) {
      await _player.stop();
      return;
    }

    try {
      await _player.stop();
      await _player.setReleaseMode(
        spec.loop ? ReleaseMode.loop : ReleaseMode.stop,
      );
      await _player.setVolume(spec.volume);
      await _player.play(AssetSource(spec.path));
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('BrewAudioService: $e\n$st');
      }
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }

  static _SoundSpec? _soundFor(CoffeeMachinePhase phase) {
    return switch (phase) {
      CoffeeMachinePhase.preparing => const _SoundSpec('sounds/power_on.wav', volume: 0.5),
      CoffeeMachinePhase.grindingBeans =>
        const _SoundSpec('sounds/grind.wav', loop: true, volume: 0.45),
      CoffeeMachinePhase.brewing =>
        const _SoundSpec('sounds/brew.wav', loop: true, volume: 0.4),
      CoffeeMachinePhase.addingMilk =>
        const _SoundSpec('sounds/pour.wav', loop: true, volume: 0.5),
      CoffeeMachinePhase.addingFlavor => const _SoundSpec('sounds/blip.wav', volume: 0.35),
      CoffeeMachinePhase.addingToppings => const _SoundSpec('sounds/blip.wav', volume: 0.3),
      CoffeeMachinePhase.finalizing =>
        const _SoundSpec('sounds/steam.wav', loop: true, volume: 0.35),
      CoffeeMachinePhase.completed => const _SoundSpec('sounds/complete.wav', volume: 0.55),
      _ => null,
    };
  }
}

class _SoundSpec {
  const _SoundSpec(this.path, {this.loop = false, this.volume = 0.5});

  final String path;
  final bool loop;
  final double volume;
}
