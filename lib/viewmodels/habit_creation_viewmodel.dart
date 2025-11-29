import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../repositories/habit_repository.dart';
import 'package:provider/provider.dart';
import 'dashboard_viewmodel.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

final _notificationRepository = NotificationRepository();

class HabitCreationViewModel extends ChangeNotifier {
  final HabitRepository _habitRepository = HabitRepository();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> createHabit(
      String name,
      String description,
      String frequency,
      TimeOfDay time,
      BuildContext context,
      ) async {
    // Validações
    if (name.isEmpty) {
      _errorMessage = 'Por favor, insira um nome para o hábito';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final habit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: '', // Virá do serviço de autenticação
        name: name,
        description: description,
        frequency: frequency,
        time: '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await _habitRepository.createHabit(habit);

      final notification = HabitNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Novo hábito criado',
        message: 'Você adicionou o hábito "${habit.name}"',
        type: 'reminder',
        isRead: false,
        createdAt: DateTime.now(),
      );

      await _notificationRepository.createNotification(notification);

      if (context.mounted) {
        // força recarregar a lista da dashboard
        await context.read<DashboardViewModel>().loadHabits();

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hábito criado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _errorMessage = 'Erro ao criar hábito: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}