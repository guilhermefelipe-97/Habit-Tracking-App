import '../services/firestore_service.dart';

class ProgressRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// Busca dados de progresso para um período ('week', 'month', 'year')
  Future<Map<String, dynamic>> getProgressData(String period) async {
    try {
      final data = await _firestoreService.getProgressData(period);

      return {
        'totalHabits': data['totalHabits'] ?? 0,
        'completionRate':
        (data['completionRate'] as num?)?.toDouble() ?? 0.0,
        'bestStreak': data['bestStreak'] ?? 0,
        'dailyProgressData': data['dailyProgressData'] ?? <double>[],
        'completedDays': data['completedDays'] ?? <String>[],
        // ainda não temos cálculo de topHabits: volta lista vazia
        'topHabits': <Map<String, dynamic>>[],
      };
    } catch (e) {
      rethrow;
    }
  }

  /// Progresso diário (usado se quiser detalhar um dia específico)
  Future<Map<String, int>> getDailyProgress(DateTime date) async {
    try {
      return await _firestoreService.getDailyProgress(date);
    } catch (e) {
      rethrow;
    }
  }

  /// Progresso semanal
  Future<List<int>> getWeeklyProgress(DateTime startDate) async {
    try {
      return await _firestoreService.getWeeklyProgress(startDate);
    } catch (e) {
      rethrow;
    }
  }

  /// Progresso mensal
  Future<List<int>> getMonthlyProgress(int year, int month) async {
    try {
      return await _firestoreService.getMonthlyProgress(year, month);
    } catch (e) {
      rethrow;
    }
  }

  /// Melhor sequência (streak)
  Future<int> getBestStreak() async {
    try {
      return await _firestoreService.getBestStreak();
    } catch (e) {
      rethrow;
    }
  }

  /// Sequência atual
  Future<int> getCurrentStreak() async {
    try {
      return await _firestoreService.getCurrentStreak();
    } catch (e) {
      rethrow;
    }
  }

  /// Taxa de conclusão (%)
  Future<double> getCompletionRate() async {
    try {
      return await _firestoreService.getCompletionRate();
    } catch (e) {
      rethrow;
    }
  }

  /// Dias em que houve pelo menos um hábito completado
  Future<List<DateTime>> getCompletedDays() async {
    try {
      return await _firestoreService.getCompletedDays();
    } catch (e) {
      rethrow;
    }
  }
}