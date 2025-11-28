import '../models/achievement_model.dart';
import '../services/firestore_service.dart';

class AchievementRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// Busca todos os dados de gamificação do usuário
  Future<Map<String, dynamic>> getGamificationData() async {
    try {
      return await _firestoreService.getGamificationData();
    } catch (e) {
      rethrow;
    }
  }

  /// Busca todas as conquistas
  Future<List<Achievement>> getAllAchievements() async {
    try {
      final data = await _firestoreService.getAllAchievements();
      return data
          .map((item) => Achievement.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Busca conquistas desbloqueadas
  Future<List<Achievement>> getUnlockedAchievements() async {
    try {
      final data = await _firestoreService.getUnlockedAchievements();
      return data
          .map((item) => Achievement.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Busca conquistas bloqueadas
  Future<List<Achievement>> getLockedAchievements() async {
    try {
      final data = await _firestoreService.getLockedAchievements();
      return data
          .map((item) => Achievement.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Desbloqueia uma conquista
  Future<void> unlockAchievement(String achievementId) async {
    try {
      await _firestoreService.unlockAchievement(achievementId);
    } catch (e) {
      rethrow;
    }
  }

  /// Busca total de pontos do usuário
  Future<int> getTotalPoints() async {
    try {
      return await _firestoreService.getTotalPoints();
    } catch (e) {
      rethrow;
    }
  }

  /// Busca nível do usuário
  Future<int> getUserLevel() async {
    try {
      return await _firestoreService.getUserLevel();
    } catch (e) {
      rethrow;
    }
  }

  /// Adiciona pontos ao usuário
  Future<void> addPoints(int points) async {
    try {
      await _firestoreService.addPoints(points);
    } catch (e) {
      rethrow;
    }
  }
}