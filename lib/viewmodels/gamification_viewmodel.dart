import 'package:flutter/material.dart';
import '../models/achievement_model.dart';
import '../repositories/achievement_repository.dart';

class GamificationViewModel extends ChangeNotifier {
  final AchievementRepository _achievementRepository = AchievementRepository();

  bool _isLoading = false;
  int _totalPoints = 0;
  int _userLevel = 1;
  int _currentStreak = 0;
  List<Achievement> _achievements = [];

  bool get isLoading => _isLoading;
  int get totalPoints => _totalPoints;
  int get userLevel => _userLevel;
  int get currentStreak => _currentStreak;
  int get totalAchievements => _achievements.length;
  int get unlockedCount => _achievements.where((a) => a.isUnlocked).length;

  List<Achievement> get unlockedAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();
  List<Achievement> get lockedAchievements =>
      _achievements.where((a) => !a.isUnlocked).toList();

  Future<void> loadAchievements() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _achievementRepository.getGamificationData();

      _totalPoints = data['totalPoints'] as int? ?? 0;
      _userLevel = data['userLevel'] as int? ?? 1;
      _currentStreak = data['currentStreak'] as int? ?? 0;
      _achievements = (data['achievements'] as List?)
          ?.map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList() ?? [];
    } catch (e) {
      print('Erro ao carregar conquistas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> unlockAchievement(String achievementId) async {
    try {
      final index = _achievements.indexWhere((a) => a.id == achievementId);
      if (index != -1) {
        _achievements[index].isUnlocked = true;
        _totalPoints += _achievements[index].points;
        _userLevel = (_totalPoints ~/ 1000) + 1;

        await _achievementRepository.unlockAchievement(achievementId);
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao desbloquear conquista: $e');
    }
  }
}