import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static final NotificationService _instance = NotificationService._internal();

  final StreamController<String> _notificationStream =
  StreamController<String>.broadcast();

  NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  /// Inicializa o serviço de notificações
  Future<void> initialize() async {
    try {
      // Solicita permissão para notificações
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        sound: true,
        provisional: false,
      );

      // Obtém o token FCM
      final token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      // Listener para mensagens em primeiro plano
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Listener para mensagens quando o app é aberto a partir de notificação
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

      // Listener para token renovado
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        print('Token renovado: $newToken');
        _updateTokenOnServer(newToken);
      });

      print('Notificações inicializadas com sucesso');
    } catch (e) {
      print('Erro ao inicializar notificações: $e');
    }
  }

  /// Obtém o token FCM do dispositivo
  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('Erro ao obter token FCM: $e');
      return null;
    }
  }

  /// Escuta notificações
  Stream<String> get notificationStream => _notificationStream.stream;

  /// Manipula notificações recebidas em primeiro plano
  void _handleForegroundMessage(RemoteMessage message) {
    print('Notificação em primeiro plano:');
    print('Título: ${message.notification?.title}');
    print('Corpo: ${message.notification?.body}');
    print('Dados: ${message.data}');

    // Adiciona à stream para notificar listeners
    if (message.data.containsKey('habitId')) {
      _notificationStream.add(message.data['habitId'] as String);
    }

    // TODO: Mostrar notificação visual local usando flutter_local_notifications
  }

  /// Manipula notificações recebidas em segundo plano/quando o app é aberto
  void _handleBackgroundMessage(RemoteMessage message) {
    print('Notificação recebida (app aberto):');
    print('Título: ${message.notification?.title}');
    print('Corpo: ${message.notification?.body}');
    print('Dados: ${message.data}');

    // Adiciona à stream para notificar listeners
    if (message.data.containsKey('habitId')) {
      _notificationStream.add(message.data['habitId'] as String);
    }
  }

  /// Agenda uma notificação local
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    Map<String, String>? payload,
  }) async {
    try {
      // TODO: Usar flutter_local_notifications para agendar
      // Exemplo:
      // await _localNotifications.zonedSchedule(
      //   0,
      //   title,
      //   body,
      //   tz.TZDateTime.from(scheduledTime, tz.local),
      //   const NotificationDetails(
      //     android: AndroidNotificationDetails(...),
      //     iOS: DarwinNotificationDetails(...),
      //   ),
      // );
      print('Notificação agendada para: $scheduledTime');
    } catch (e) {
      print('Erro ao agendar notificação: $e');
    }
  }

  /// Atualiza o token no servidor
  Future<void> _updateTokenOnServer(String token) async {
    try {
      // TODO: Salvar token no Firestore
      print('Token atualizado no servidor: $token');
    } catch (e) {
      print('Erro ao atualizar token: $e');
    }
  }

  /// Subscreve a um tópico
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('Inscrito no tópico: $topic');
    } catch (e) {
      print('Erro ao se inscrever no tópico: $e');
    }
  }

  /// Desinscreve de um tópico
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('Desinscrito do tópico: $topic');
    } catch (e) {
      print('Erro ao se desinscrever do tópico: $e');
    }
  }

  /// Verifica permissão de notificações
  Future<NotificationSettings> getNotificationSettings() async {
    return await _firebaseMessaging.getNotificationSettings();
  }

  /// Dispose do serviço
  void dispose() {
    _notificationStream.close();
  }
}