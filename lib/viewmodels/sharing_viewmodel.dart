import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../repositories/sharing_repository.dart';

class SharingViewModel extends ChangeNotifier {
  final SharingRepository _sharingRepository = SharingRepository();

  bool _isLoading = false;
  String _userName = '';
  String _userPhotoUrl = '';
  int _totalPoints = 0;
  int _completedHabits = 0;
  int _currentStreak = 0;

  bool _isFacebookConnected = false;
  bool _isTwitterConnected = false;
  bool _isInstagramConnected = false;
  bool _isWhatsappConnected = false;

  List<Map<String, String>> _shareHistory = [];

  bool get isLoading => _isLoading;
  String get userName => _userName;
  String get userPhotoUrl => _userPhotoUrl;
  int get totalPoints => _totalPoints;
  int get completedHabits => _completedHabits;
  int get currentStreak => _currentStreak;

  bool get isFacebookConnected => _isFacebookConnected;
  bool get isTwitterConnected => _isTwitterConnected;
  bool get isInstagramConnected => _isInstagramConnected;
  bool get isWhatsappConnected => _isWhatsappConnected;

  List<Map<String, String>> get shareHistory => _shareHistory;

  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _sharingRepository.getUserData();

      _userName = data['userName'] as String? ?? '';
      _userPhotoUrl = data['userPhotoUrl'] as String? ?? '';
      _totalPoints = data['totalPoints'] as int? ?? 0;
      _completedHabits = data['completedHabits'] as int? ?? 0;
      _currentStreak = data['currentStreak'] as int? ?? 0;
      _shareHistory = (data['shareHistory'] as List?)
          ?.map((e) => Map<String, String>.from(e as Map))
          .toList() ?? [];
    } catch (e) {
      print('Erro ao carregar dados do usuário: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> shareProgress(BuildContext context) async {
    final message = 'Completei $_completedHabits hábitos! Junte-se a mim e acompanhe seus hábitos 💪';
    await Share.share(message);
    await _addToHistory('progress', 'native');
  }

  Future<void> shareAchievements(BuildContext context) async {
    final message = 'Desbloqueei novas conquistas! Venha competir comigo 🏆';
    await Share.share(message);
    await _addToHistory('achievements', 'native');
  }

  Future<void> shareStreak(BuildContext context) async {
    final message = 'Já estou com $_currentStreak dias consecutivos de hábitos! 🔥';
    await Share.share(message);
    await _addToHistory('streak', 'native');
  }

  Future<void> sharePoints(BuildContext context) async {
    final message = 'Acumulei $_totalPoints pontos rastreando meus hábitos! ⭐';
    await Share.share(message);
    await _addToHistory('points', 'native');
  }

  Future<void> connectFacebook(BuildContext context) async {
    try {
      // TODO: Implementar autenticação Facebook
      _isFacebookConnected = !_isFacebookConnected;
      notifyListeners();
    } catch (e) {
      print('Erro ao conectar Facebook: $e');
    }
  }

  Future<void> connectTwitter(BuildContext context) async {
    try {
      // TODO: Implementar autenticação Twitter
      _isTwitterConnected = !_isTwitterConnected;
      notifyListeners();
    } catch (e) {
      print('Erro ao conectar Twitter: $e');
    }
  }

  Future<void> connectInstagram(BuildContext context) async {
    try {
      // TODO: Implementar autenticação Instagram
      _isInstagramConnected = !_isInstagramConnected;
      notifyListeners();
    } catch (e) {
      print('Erro ao conectar Instagram: $e');
    }
  }

  Future<void> shareViaWhatsapp(BuildContext context) async {
    try {
      final message = Uri.encodeFull('Estou rastreando meus hábitos no app! Baixe também! 📱');
      // TODO: Abrir WhatsApp com mensagem
      _isWhatsappConnected = true;
      notifyListeners();
    } catch (e) {
      print('Erro ao compartilhar WhatsApp: $e');
    }
  }

  Future<void> _addToHistory(String type, String platform) async {
    try {
      await _sharingRepository.recordShare(type, platform);
      await loadUserData();
    } catch (e) {
      print('Erro ao registrar compartilhamento: $e');
    }
  }
}