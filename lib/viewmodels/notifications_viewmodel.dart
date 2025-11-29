  import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

class NotificationsViewModel extends ChangeNotifier {
  final NotificationRepository _notificationRepository = NotificationRepository();

  List<HabitNotification> _notifications = [];
  bool _isLoading = false;

  List<HabitNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notifications = await _notificationRepository.getNotifications();
      // Ordenar por data decrescente
      _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print('Erro ao carregar notificações: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index].isRead = true;
        await _notificationRepository.markAsRead(notificationId);
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao marcar como lido: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      for (var notification in _notifications) {
        notification.isRead = true;
        await _notificationRepository.markAsRead(notification.id);
      }
      notifyListeners();
    } catch (e) {
      print('Erro ao marcar todas como lidas: $e');
    }
  }

  Future<void> dismissNotification(String notificationId) async {
    try {
      await _notificationRepository.deleteNotification(notificationId);
      _notifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();
    } catch (e) {
      print('Erro ao remover notificação: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      for (var notification in _notifications) {
        await _notificationRepository.deleteNotification(notification.id);
      }
      _notifications.clear();
      notifyListeners();
    } catch (e) {
      print('Erro ao limpar notificações: $e');
    }
  }
}