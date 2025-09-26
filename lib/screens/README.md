# 📱 Screens - Camada de Interface do Usuário

## 📋 Propósito
Esta pasta contém todas as telas (páginas) do aplicativo, organizadas por módulo funcional:
- Interfaces completas e responsivas
- Gerenciamento de estado local
- Navegação entre telas
- Validação de formulários
- Integração com serviços e repositórios

## 🏗️ Estrutura Recomendada

```
screens/
├── README.md                    # Este arquivo
├── splash_screen.dart           # Tela de carregamento inicial
├── login_screen.dart            # Tela de login
├── forgot_password_screen.dart  # Recuperação de senha
├── tela_inicial.dart           # Dashboard principal ✅ IMPLEMENTADA
├── auth/
│   ├── login_screen.dart       # Variação modular do login
│   ├── register_screen.dart    # Cadastro de usuário
│   └── verify_email_screen.dart # Verificação de email
├── escalas/
│   ├── escalas_screen.dart     # Lista de escalas
│   ├── detalhes_escala_screen.dart # Detalhes de uma escala
│   ├── calendario_escalas_screen.dart # Calendário de escalas
│   └── confirmar_presenca_screen.dart # Confirmação de presença
├── despesas/
│   ├── despesas_screen.dart    # Lista de despesas
│   ├── nova_despesa_screen.dart # Criar nova despesa
│   ├── editar_despesa_screen.dart # Editar despesa existente
│   ├── detalhes_despesa_screen.dart # Visualizar despesa
│   └── relatorio_despesas_screen.dart # Relatório de despesas
├── chamados/
│   ├── chamados_screen.dart    # Lista de chamados
│   ├── novo_chamado_screen.dart # Criar novo chamado
│   ├── detalhes_chamado_screen.dart # Visualizar chamado
│   └── chat_chamado_screen.dart # Chat do chamado
├── perfil/
│   ├── perfil_screen.dart      # Visualizar perfil
│   ├── editar_perfil_screen.dart # Editar dados do perfil
│   ├── alterar_senha_screen.dart # Alterar senha
│   ├── configuracoes_screen.dart # Configurações do app
│   └── sobre_screen.dart       # Sobre o aplicativo
└── common/
    ├── error_screen.dart       # Tela de erro genérica
    ├── loading_screen.dart     # Tela de carregamento
    ├── no_internet_screen.dart # Sem conexão
    └── maintenance_screen.dart # Manutenção do sistema
```

## 🎯 Objetivos da Implementação

1. **Responsividade**: Adaptação automática a diferentes tamanhos
2. **Acessibilidade**: Suporte completo a screen readers
3. **Performance**: Carregamento otimizado e lazy loading
4. **UX Consistente**: Padrões visuais unificados
5. **Testabilidade**: Widgets facilmente testáveis
6. **Manutenibilidade**: Código organizado e reutilizável

## 🔄 Ciclo de Vida Típico

```
initState()
    ↓
loadData() → setState() → build()
    ↓
User Interaction
    ↓
handleAction() → setState() → build()
    ↓
dispose()
```