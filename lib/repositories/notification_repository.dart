import '../models/notification_model.dart';
import '../services/firestore_service.dart';

class NotificationRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// Busca todas as notificações do usuário
  Future<List<HabitNotification>> getNotifications() async {
    try {
      return await _firestoreService.getNotifications();
    } catch (e) {
      rethrow;
    }
  }

  /// Cria uma nova notificação
  Future<void> createNotification(HabitNotification notification) async {
    try {
      await _firestoreService.createNotification(notification);
    } catch (e) {
      rethrow;
    }
  }

  /// Marca uma notificação como lida
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestoreService.markNotificationAsRead(notificationId);
    } catch (e) {
      rethrow;
    }
  }

  /// Marca todas as notificações como lidas
  Future<void> markAllAsRead() async {
    try {
      await _firestoreService.markAllNotificationsAsRead();
    } catch (e) {
      rethrow;
    }
  }

  /// Deleta uma notificação
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestoreService.deleteNotification(notificationId);
    } catch (e) {
      rethrow;
    }
  }

  /// Busca notificações não lidas
  Future<int> getUnreadCount() async {
    try {
      return await _firestoreService.getUnreadNotificationCount();
    } catch (e) {
      rethrow;
    }
  }
}