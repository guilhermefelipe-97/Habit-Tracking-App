import '../services/firestore_service.dart';

class SharingRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// Busca dados de compartilhamento do usuário
  Future<Map<String, dynamic>> getUserData() async {
    try {
      return await _firestoreService.getUserSharingData();
    } catch (e) {
      rethrow;
    }
  }

  /// Registra um compartilhamento na história
  Future<void> recordShare(String type, String platform) async {
    try {
      await _firestoreService.recordShare(type, platform);
    } catch (e) {
      rethrow;
    }
  }

  /// Busca histórico de compartilhamentos
  Future<List<Map<String, String>>> getShareHistory() async {
    try {
      return await _firestoreService.getShareHistory();
    } catch (e) {
      rethrow;
    }
  }

  /// Conecta rede social (Facebook, Twitter, Instagram)
  Future<bool> connectSocialNetwork(String platform, String token) async {
    try {
      return await _firestoreService.connectSocialNetwork(platform, token);
    } catch (e) {
      rethrow;
    }
  }

  /// Desconecta rede social
  Future<void> disconnectSocialNetwork(String platform) async {
    try {
      await _firestoreService.disconnectSocialNetwork(platform);
    } catch (e) {
      rethrow;
    }
  }

  /// Verifica se rede social está conectada
  Future<bool> isSocialNetworkConnected(String platform) async {
    try {
      return await _firestoreService.isSocialNetworkConnected(platform);
    } catch (e) {
      rethrow;
    }
  }
}