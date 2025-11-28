import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  /// Alterna visibilidade da senha
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  /// Alterna visibilidade da confirmação de senha
  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  /// Registra um novo usuário
  Future<bool> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String displayName,
  }) async {
    // Validar entradas
    final validationError = _validateInput(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      displayName: displayName,
    );

    if (validationError.isNotEmpty) {
      _errorMessage = validationError;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Tenta registrar o usuário
      final user = await _authService.register(
        email,
        password,
        displayName,
      );

      if (user != null) {
        _isLoading = false;
        _errorMessage = '';
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Erro ao registrar. Tente novamente.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      // Captura erro e extrai mensagem
      _errorMessage = _parseError(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Valida as entradas do usuário
  String _validateInput({
    required String email,
    required String password,
    required String confirmPassword,
    required String displayName,
  }) {
    // Validar nome
    if (displayName.trim().isEmpty) {
      return 'Por favor, insira seu nome';
    }

    if (displayName.trim().length < 3) {
      return 'Nome deve ter pelo menos 3 caracteres';
    }

    // Validar email
    if (email.trim().isEmpty) {
      return 'Por favor, insira seu email';
    }

    if (!_isValidEmail(email)) {
      return 'Por favor, insira um email válido';
    }

    // Validar senha
    if (password.isEmpty) {
      return 'Por favor, insira uma senha';
    }

    if (password.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }

    // Validar confirmação de senha
    if (confirmPassword.isEmpty) {
      return 'Por favor, confirme sua senha';
    }

    if (password != confirmPassword) {
      return 'As senhas não correspondem';
    }

    return ''; // Sem erros
  }

  /// Valida formato de email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Extrai mensagem de erro do exception
  String _parseError(String errorString) {
    // Se for exceção do Firebase Auth
    if (errorString.contains('email-already-in-use')) {
      return 'Este email já está registrado';
    }
    if (errorString.contains('weak-password')) {
      return 'Senha muito fraca (mínimo 6 caracteres)';
    }
    if (errorString.contains('invalid-email')) {
      return 'Email inválido';
    }
    if (errorString.contains('network-request-failed')) {
      return 'Erro de conexão. Verifique sua internet';
    }
    if (errorString.contains('Usuário não encontrado')) {
      return 'Usuário não encontrado';
    }
    if (errorString.contains('Senha incorreta')) {
      return 'Senha incorreta';
    }

    // Mensagem padrão se não conseguir identificar
    return 'Erro ao registrar. Tente novamente.';
  }

  /// Limpa mensagens de erro
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}