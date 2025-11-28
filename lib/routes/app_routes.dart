import 'package:flutter/material.dart';
import '../views/login/login_view.dart';
import '../views/register/register_view.dart';
import '../views/dashboard/dashboard_view.dart';
import '../views/habit_creation/habit_creation_view.dart';
import '../views/notifications/notifications_view.dart';
import '../views/progress/progress_view.dart';
import '../views/gamification/gamification_view.dart';
import '../views/sharing/sharing_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String habitCreation = '/habit-creation';
  static const String notifications = '/notifications';
  static const String progress = '/progress';
  static const String gamification = '/gamification';
  static const String sharing = '/sharing';

  static Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      login: (context) => const LoginView(),
      register: (context) => const RegisterView(),
      dashboard: (context) => const DashboardView(),
      habitCreation: (context) => const HabitCreationView(),
      notifications: (context) => const NotificationsView(),
      progress: (context) => const ProgressView(),
      gamification: (context) => const GamificationView(),
      sharing: (context) => const SharingView(),
    };
  }

  /// Navega para login
  static void goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(login);
  }

  /// Navega para registro
  static void goToRegister(BuildContext context) {
    Navigator.of(context).pushNamed(register);
  }

  /// Navega para dashboard
  static void goToDashboard(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(dashboard);
  }

  /// Navega para criação de hábito
  static void goToHabitCreation(BuildContext context) {
    Navigator.of(context).pushNamed(habitCreation);
  }

  /// Navega para notificações
  static void goToNotifications(BuildContext context) {
    Navigator.of(context).pushNamed(notifications);
  }

  /// Navega para progresso
  static void goToProgress(BuildContext context) {
    Navigator.of(context).pushNamed(progress);
  }

  /// Navega para gamificação
  static void goToGamification(BuildContext context) {
    Navigator.of(context).pushNamed(gamification);
  }

  /// Navega para compartilhamento
  static void goToSharing(BuildContext context) {
    Navigator.of(context).pushNamed(sharing);
  }
}