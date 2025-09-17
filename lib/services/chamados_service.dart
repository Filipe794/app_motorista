// TODO: Implementar serviço de chamados
// TODO: Conectar com API de suporte/chamados
// TODO: Implementar categorização de chamados
// TODO: Adicionar upload de anexos
// TODO: Implementar notificações de atualização de chamados
// TODO: Adicionar chat/mensagens no chamado

class ChamadosService {
  // TODO: Implementar singleton pattern
  static ChamadosService? _instance;
  static ChamadosService get instance => _instance ??= ChamadosService._();
  ChamadosService._();

  // TODO: Buscar chamados do motorista
  Future<List<dynamic>> getChamadosMotorista(String motoristaId) async {
    throw UnimplementedError('TODO: Implementar busca de chamados');
  }

  // TODO: Criar novo chamado
  Future<bool> criarChamado(Map<String, dynamic> dadosChamado) async {
    throw UnimplementedError('TODO: Implementar criação de chamado');
  }

  // TODO: Buscar detalhes de um chamado
  Future<dynamic> getDetalhesChamado(String chamadoId) async {
    throw UnimplementedError('TODO: Implementar busca de detalhes');
  }

  // TODO: Adicionar comentário ao chamado
  Future<bool> adicionarComentario(String chamadoId, String comentario) async {
    throw UnimplementedError('TODO: Implementar adição de comentário');
  }

  // TODO: Upload de anexo
  Future<bool> uploadAnexo(String chamadoId, String caminhoArquivo) async {
    throw UnimplementedError('TODO: Implementar upload de anexo');
  }

  // TODO: Fechar chamado
  Future<bool> fecharChamado(String chamadoId, String motivoFechamento) async {
    throw UnimplementedError('TODO: Implementar fechamento de chamado');
  }

  // TODO: Buscar categorias de chamados
  Future<List<dynamic>> getCategoriasChamados() async {
    throw UnimplementedError('TODO: Implementar busca de categorias');
  }

  // TODO: Buscar status disponíveis
  Future<List<dynamic>> getStatusChamados() async {
    throw UnimplementedError('TODO: Implementar busca de status');
  }
}