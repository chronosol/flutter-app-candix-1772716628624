abstract class GameRepository {
  Future<int> getHighScore();
  Future<void> saveHighScore(int score);
}
