import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../repositories/habit_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final HabitRepository _habitRepository = HabitRepository();

  List<Habit> _habits = [];
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  int get totalHabits => _habits.length;
  int get completedHabits => _habits.where((h) => h.isCompleted).length;
  double get progressPercentage => totalHabits == 0
      ? 0
      : (completedHabits / totalHabits) * 100;

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    try {
      _habits = await _habitRepository.getAllHabits();
    } catch (e) {
      print('Erro ao carregar hábitos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleHabit(String habitId) async {
    try {
      final habitIndex = _habits.indexWhere((h) => h.id == habitId);
      if (habitIndex != -1) {
        _habits[habitIndex].isCompleted = !_habits[habitIndex].isCompleted;
        await _habitRepository.updateHabit(_habits[habitIndex]);
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao atualizar hábito: $e');
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      await _habitRepository.deleteHabit(habitId);
      _habits.removeWhere((h) => h.id == habitId);
      notifyListeners();
    } catch (e) {
      print('Erro ao deletar hábito: $e');
    }
  }
}