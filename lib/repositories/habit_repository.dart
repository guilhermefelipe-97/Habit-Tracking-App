import '../models/habit_model.dart';
import '../services/firestore_service.dart';

class HabitRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// Busca todos os hábitos do usuário
  Future<List<Habit>> getAllHabits() async {
    try {
      return await _firestoreService.getAllHabits();
    } catch (e) {
      rethrow;
    }
  }

  /// Cria um novo hábito
  Future<void> createHabit(Habit habit) async {
    try {
      await _firestoreService.createHabit(habit);
    } catch (e) {
      rethrow;
    }
  }

  /// Atualiza um hábito existente
  Future<void> updateHabit(Habit habit) async {
    try {
      await _firestoreService.updateHabit(habit);
    } catch (e) {
      rethrow;
    }
  }

  /// Marca um hábito como completo para um dia específico
  Future<void> completeHabitForDay(String habitId, DateTime date) async {
    try {
      await _firestoreService.completeHabitForDay(habitId, date);
    } catch (e) {
      rethrow;
    }
  }

  /// Deleta um hábito
  Future<void> deleteHabit(String habitId) async {
    try {
      await _firestoreService.deleteHabit(habitId);
    } catch (e) {
      rethrow;
    }
  }

  /// Busca um hábito pelo ID
  Future<Habit?> getHabitById(String habitId) async {
    try {
      return await _firestoreService.getHabitById(habitId);
    } catch (e) {
      rethrow;
    }
  }

  /// Busca hábitos completados em um intervalo de datas
  Future<List<Habit>> getCompletedHabits(DateTime startDate, DateTime endDate) async {
    try {
      return await _firestoreService.getCompletedHabits(startDate, endDate);
    } catch (e) {
      rethrow;
    }
  }
}