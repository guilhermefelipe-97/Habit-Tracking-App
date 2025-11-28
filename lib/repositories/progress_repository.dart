import '../services/firestore_service.dart';

class ProgressRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// Busca dados de progresso para um período (week, month, year)
  Future<Map<String, dynamic>> getProgressData(String period) async {
    try {
      return await _firestoreService.getProgressData(period);
    } catch (e) {
      rethrow;
    }
  }

  /// Busca progresso diário
  Future<Map<String, int>> getDailyProgress(DateTime date) async {
    try {
      return await _firestoreService.getDailyProgress(date);
    } catch (e) {
      rethrow;
    }
  }

  /// Busca progresso semanal
  Future<List<int>> getWeeklyProgress(DateTime startDate) async {
    try {
      return await _firestoreService.getWeeklyProgress(startDate);
    } catch (e) {
      rethrow;
    }
  }

  /// Busca progresso mensal
  Future<List<int>> getMonthlyProgress(int year, int month) async {
    try {
      return await _firestoreService.getMonthlyProgress(year, month);
    } catch (e) {
      rethrow;
    }
  }

  /// Busca melhor sequência (streak) do usuário
  Future<int> getBestStreak() async {
    try {
      return await _firestoreService.getBestStreak();
    } catch (e) {
      rethrow;
    }
  }

  /// Busca sequência atual do usuário
  Future<int> getCurrentStreak() async {
    try {
      return await _firestoreService.getCurrentStreak();
    } catch (e) {
      rethrow;
    }
  }

  /// Busca taxa de conclusão (em %)
  Future<double> getCompletionRate() async {
    try {
      return await _firestoreService.getCompletionRate();
    } catch (e) {
      rethrow;
    }
  }

  /// Busca dias em que hábitos foram completados
  Future<List<DateTime>> getCompletedDays() async {
    try {
      return await _firestoreService.getCompletedDays();
    } catch (e) {
      rethrow;
    }
  }
}