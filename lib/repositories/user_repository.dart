import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class UserRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  /// Busca dados do usuário atual
  Future<firebase_auth.User?> getCurrentUser() async {
    try {
      return await _firestoreService.getUserData();
    } catch (e) {
      rethrow;
    }
  }

  /// Atualiza perfil do usuário
  Future<void> updateUserProfile({
    required String name,
    String? photoUrl,
    String? bio,
  }) async {
    try {
      await _firestoreService.updateUserProfile(
        name: name,
        photoUrl: photoUrl,
        bio: bio,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Atualiza foto de perfil
  Future<String> updateProfilePhoto(String imagePath) async {
    try {
      return await _firestoreService.uploadProfilePhoto(imagePath);
    } catch (e) {
      rethrow;
    }
  }

  /// Busca preferências do usuário
  Future<Map<String, dynamic>> getUserPreferences() async {
    try {
      return await _firestoreService.getUserPreferences();
    } catch (e) {
      rethrow;
    }
  }

  /// Atualiza preferências do usuário
  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    try {
      await _firestoreService.updateUserPreferences(preferences);
    } catch (e) {
      rethrow;
    }
  }

  /// Deleta conta do usuário (SEM SENHA)
  Future<void> deleteAccount() async {
    try {
      // Primeiro deleta dados do Firestore
      await _firestoreService.deleteUserAccount();
      // Depois deleta a conta do Firebase Auth
      try {
        await _authService.deleteAccount('');
      } catch (e) {
        // Se falhar, apenas loga o erro
        print('Erro ao deletar conta Auth: $e');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Deleta conta do usuário (COM SENHA - mais seguro)
  Future<void> deleteAccountWithPassword(String password) async {
    try {
      // Primeiro deleta dados do Firestore
      await _firestoreService.deleteUserAccount();
      // Depois deleta a conta do Firebase Auth
      await _authService.deleteAccount(password);
    } catch (e) {
      rethrow;
    }
  }

  /// Faz logout do usuário
  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      rethrow;
    }
  }
}