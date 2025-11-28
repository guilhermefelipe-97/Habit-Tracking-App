import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Por favor, preencha todos os campos';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);

      if (user != null) {
        // Login bem-sucedido
        _errorMessage = null;
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        _errorMessage = 'Email ou senha inválidos';
      }
    } catch (e) {
      _errorMessage = _getErrorMessage(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'Usuário não encontrado';
    } else if (error.contains('wrong-password')) {
      return 'Senha incorreta';
    } else if (error.contains('invalid-email')) {
      return 'Email inválido';
    } else if (error.contains('user-disabled')) {
      return 'Usuário desativado';
    } else if (error.contains('too-many-requests')) {
      return 'Muitas tentativas. Tente novamente mais tarde';
    } else if (error.contains('network')) {
      return 'Erro de conexão. Verifique sua internet';
    }
    return 'Erro ao fazer login. Tente novamente.';
  }
}