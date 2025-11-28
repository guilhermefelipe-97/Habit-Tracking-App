import 'package:flutter/material.dart';
import '../repositories/progress_repository.dart';

class ProgressViewModel extends ChangeNotifier {
  final ProgressRepository _progressRepository = ProgressRepository();

  bool _isLoading = false;
  int _totalHabits = 0;
  double _completionRate = 0;
  int _bestStreak = 0;
  List<double> _dailyProgressData = [];
  List<DateTime> _completedDays = [];
  List<Map<String, dynamic>> _topHabits = [];

  bool get isLoading => _isLoading;
  int get totalHabits => _totalHabits;
  double get completionRate => _completionRate;
  int get bestStreak => _bestStreak;
  List<double> get dailyProgressData => _dailyProgressData;
  List<DateTime> get completedDays => _completedDays;
  List<Map<String, dynamic>> get topHabits => _topHabits;

  Future<void> loadProgressData(String period) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _progressRepository.getProgressData(period);

      _totalHabits = data['totalHabits'] as int? ?? 0;
      _completionRate = data['completionRate'] as double? ?? 0;
      _bestStreak = data['bestStreak'] as int? ?? 0;
      _dailyProgressData = (data['dailyProgressData'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList() ?? [];
      _completedDays = (data['completedDays'] as List?)
          ?.map((e) => DateTime.parse(e as String))
          .toList() ?? [];
      _topHabits = (data['topHabits'] as List?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ?? [];
    } catch (e) {
      print('Erro ao carregar dados de progresso: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}