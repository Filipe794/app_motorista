// TODO: Implementar autenticação com API
// TODO: Adicionar login por email/senha
// TODO: Implementar autenticação biométrica
// TODO: Adicionar persistência de token
// TODO: Implementar refresh token
// TODO: Adicionar logout automático por expiração

class AuthService {
  // TODO: Adicionar instância singleton
  // TODO: Implementar método de login
  // TODO: Implementar método de logout
  // TODO: Adicionar verificação de token válido
  // TODO: Implementar renovação de token
  
  /// TODO: Método para fazer login
  Future<bool> login(String email, String password) async {
    // TODO: Implementar autenticação
    throw UnimplementedError('TODO: Implementar login');
  }
  
  /// TODO: Método para fazer logout
  Future<void> logout() async {
    // TODO: Implementar logout
    throw UnimplementedError('TODO: Implementar logout');
  }
  
  /// TODO: Verifica se usuário está autenticado
  Future<bool> isAuthenticated() async {
    // TODO: Verificar token válido
    throw UnimplementedError('TODO: Implementar verificação de autenticação');
  }
  
  /// TODO: Obtém usuário atual
  Future<Map<String, dynamic>?> getCurrentUser() async {
    // TODO: Retornar dados do usuário
    throw UnimplementedError('TODO: Implementar getCurrentUser');
  }
}