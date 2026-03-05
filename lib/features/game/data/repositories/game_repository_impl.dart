import 'package:candix/features/game/domain/repositories/game_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameRepositoryImpl implements GameRepository {
  static const String _highScoreKey = 'high_score';

  final SharedPreferences _prefs;

  GameRepositoryImpl(this._prefs);

  @override
  Future<int> getHighScore() async {
    return _prefs.getInt(_highScoreKey) ?? 0;
  }

  @override
  Future<void> saveHighScore(int score) async {
    final currentHighScore = await getHighScore();
    if (score > currentHighScore) {
      await _prefs.setInt(_highScoreKey, score);
    }
  }
}

final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.when(
    data: (data) => GameRepositoryImpl(data),
    loading: () => throw Exception('SharedPreferences not loaded'),
    error: (e, st) => throw Exception('Error loading SharedPreferences: $e'),
  );
});
