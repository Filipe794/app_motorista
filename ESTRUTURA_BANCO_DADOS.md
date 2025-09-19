  
## 📋 Visão Geral

Este documento descreve a estrutura completa do banco de dados Firestore para o App Motorista da Prefeitura. Cada coleção possui campos específicos e relacionamentos bem definidos para garantir a integridade e eficiência dos dados.

# Dúvidas

	- Como gerenciar ônibus, motorista e rota: Escalas!
	- Como definir os pontos da rota (pré-definido, escolhido pelos alunos)
	- Precisa de mais de um tipo de combustível?
	- Como fazer o controle de aprovação?
	- Nos chamados: como gerenciar os detalhes, quem cadastra ou atualiza. Precisa de solução?
	- Níveis de acesso
---
## 👥 Coleção: `Motorista`

### 📄 Propósito

Armazena informações dos motoristas e usuários do sistema.
### 🔑 Estrutura do Documento

```javascript

{

  // === DADOS PESSOAIS ===

  "cpf": "123.456.789-00",                    // String - CPF do motorista

  "nomeCompleto": "João Silva Santos",        // String - Nome completo

  "email": "joao.silva@prefeitura.gov.br",   // String - Email institucional

  "telefone": "(11) 99999-9999",             // String - Telefone de contato

  // === DADOS PROFISSIONAIS ===

  "cargo": "motorista",                       // String - Cargo/função

  "situacao": "ativo",                        // String - Status: ativo, inativo, licenca, aposentado
  
  "validadeHabilitacao": Timestamp,           // Timestamp - Validade da CNH
  
  "turno_de_trabalho"

  // === HABILITAÇÃO ===

  "numeroHabilitacao": "12345678901",         // String - Número da CNH

  "categoriaHabilitacao": ["B", "C", "D"],    // Array - Categorias habilitadas

  "validadeHabilitacao": Timestamp,           // Timestamp - Validade da CNH

  // === METADADOS ===

  "ultimoLogin": Timestamp,                   // Timestamp - Último acesso
  
  // === LOCALIZAÇÃO ===

  "localizacaoAtual": GeoPoint,               // GeoPoint - Latitude/Longitude

}

```


### 🔗 Relacionamentos

- Referenciado por: `escalas.motoristaId`, `despesas.motoristaId`, `chamados.motoristaId`

---

## 🔧 Coleção: `perfilDetalhado`


### 📄 Propósito

Dados detalhados complementares do perfil do motorista.


### 🔑 Estrutura do Documento

```javascript

{

  // === ENDEREÇO ===

  "endereco": {

    "cep": "01234-567",                       // String - CEP

    "logradouro": "Rua das Flores",           // String - Nome da rua

    "numero": "123",                          // String - Número

    "complemento": "Apto 45",                 // String - Complemento (opcional)

    "bairro": "Centro",                       // String - Bairro

    "cidade": "São Paulo",                    // String - Cidade

    "estado": "SP",                           // String - Estado (UF)

    "pais": "Brasil"                          // String - País

  },

  // === CONTATOS DE EMERGÊNCIA ===

  "contatosEmergencia": [

    {

      "nome": "Maria Silva",                  // String - Nome do contato

      "parentesco": "esposa",                 // String - Grau de parentesco

      "telefone": "(11) 88888-8888",         // String - Telefone

      "email": "maria@email.com",             // String - Email (opcional)

      "principal": true                       // Boolean - Contato principal

    }

  ],

  // === DOCUMENTOS ===

  "documentos": {

    "fotoPerfilUrl": "https://...",           // String - URL da foto de perfil

    "cpfUrl": "https://...",                  // String - URL do documento CPF

    "habilitacaoFrenteUrl": "https://...",    // String - URL CNH frente

    "habilitacaoVersoUrl": "https://...",     // String - URL CNH verso

    "comprovanteResidenciaUrl": "https://...", // String - URL comprovante

  }

```

  

---

  

## 🚗 Coleção: `veiculos`

  

### 📄 Propósito

Informações dos veículos da frota municipal.

  

### 🔑 Estrutura do Documento

```javascript

{

  // === IDENTIFICAÇÃO ===

  "placa": "ABC-1234",                        // String - Placa do veículo

  "numeroPatrimonio": "PAT001",               // String - Número do patrimônio

  "numeroFrota": "FROTA001",                  // String - Número da frota

  // === ESPECIFICAÇÕES ===

  "marca": "Mercedes-Benz",                   // String - Marca do veículo

  "modelo": "Sprinter",                       // String - Modelo

  "ano": 2022,                                // Number - Ano de fabricação

  "cor": "Branco",                            // String - Cor do veículo

  "tipoCombustivel": "diesel",                // String - Tipo: gasolina, etanol, diesel, flex, eletrico

  "capacidadePassageiros": 20,                // Number - Número de passageiros

  // === STATUS ===

  "status": "ativo",                          // String - Status: ativo, manutencao, inativo, sinistrado

  "disponivel": true,                         // Boolean - Disponível para uso do motorista (está ou não em rota)
  
  // === DOCUMENTAÇÃO ===

  "renavam": "12345678901",                   // String - Número RENAVAM

  "chassi": "9BWZZZ377VT004251",              // String - Número do chassi

  "validadeSeguro": Timestamp,                // Timestamp - Validade do seguro

  "validadeLicenciamento": Timestamp,         // Timestamp - Validade do licenciamento

  // === MANUTENÇÃO ===

  "ultimaManutencao": Timestamp,              // Timestamp - Data última manutenção

}

```

  

### 🔗 Relacionamentos

- Referenciado por: `escalas.veiculoId`, `despesas.veiculoId`, `chamados.veiculoId`

  

---

  

## 🗺️ Coleção: `rotas`

  

### 📄 Propósito

Definição de rotas e itinerários dos veículos.

  

### 🔑 Estrutura do Documento

```javascript

{

  // === INFORMAÇÕES BÁSICAS ===

  "nome": "Rota Centro-Periferia",            // String - Nome da rota

  "descricao": "Transporte de funcionários...", // String - Descrição detalhada

  "tipoRota": "urbana",                       // String - Tipo: urbana, intermunicipal, especial

  "ativa": true,                              // Boolean - Rota ativa

  "distanciaTotal": 25.5,                     // Number - Distância em KM

  "tempoEstimado": 90,                        // Number - Tempo em minutos

  // === PONTOS DA ROTA ===

  "pontos": [

    {

      "sequencia": 1,                         // Number - Ordem do ponto

      "nome": "Prefeitura Municipal",         // String - Nome do local

      "tipo": "partida",                      // String - Tipo: partida, parada, destino

      "endereco": "Praça da Sé, 1",          // String - Endereço completo

      "coordenadas": GeoPoint,                // GeoPoint - Latitude/Longitude

      "tempoParada": 0                        // Number - Tempo de parada em minutos

    }

  ],

  // === RESTRIÇÕES ===

  "restricoes": {

    "horarioFuncionamento": {

      "inicio": "06:00",                      // String - Horário início

      "fim": "22:00"                          // String - Horário fim

    },

    "diasSemana": ["segunda", "terca"],       // Array - Dias da semana

    "observacoes": "Rota sujeita a alterações" // String - Observações gerais

  }

}

```

  

### 🔗 Relacionamentos

- Referenciado por: `escalas.rotaId`

  

---

  

## 📅 Coleção: `escalas`

  

### 📄 Propósito

Escalas de trabalho dos motoristas.

  

### 🔑 Estrutura do Documento

```javascript

{

  // === IDENTIFICAÇÃO ===

  "motoristaId": "motorista_001",             // String - ID do motorista

  "veiculoId": "veiculo_001",                 // String - ID do veículo

  "rotaId": "rota_001",                       // String - ID da rota

  // === TEMPORAL ===

  "dataEscala": Timestamp,                    // Timestamp - Data da escala

  "horaInicio": Timestamp,                    // Timestamp - Hora de início

  "horaFim": Timestamp,                       // Timestamp - Hora de fim

  "duracaoTotal": 600,                        // Number - Duração em minutos

  // === STATUS ===

  "status": "agendada",                       // String - Status: agendada, em_andamento, concluida, cancelada

  "tipoEscala": "regular",                    // String - Tipo: regular, extra, substituicao, emergencial

  "prioridade": "media",                      // String - Prioridade: baixa, media, alta, critica

  // === LOCALIZAÇÃO ===

  "pontoPartida": {

    "nome": "Garagem Central",                // String - Nome do local

    "endereco": "Rua da Garagem, 100",       // String - Endereço

    "coordenadas": GeoPoint,                  // GeoPoint - Coordenadas

    "observacoes": "Verificar combustível"   // String - Observações

  },

  "pontoChegada": {

    "nome": "Garagem Central",                // String - Nome do local

    "endereco": "Rua da Garagem, 100",       // String - Endereço

    "coordenadas": GeoPoint,                  // GeoPoint - Coordenadas

    "observacoes": "Fazer limpeza"           // String - Observações

  },

  // === ROTA DETALHADA ===

  "rotaDetalhada": {

    "distanciaTotal": 120.5,                  // Number - Distância total em KM

    "tempoEstimado": 600,                     // Number - Tempo estimado em minutos

    "paradas": [

      {

        "sequencia": 1,                       // Number - Ordem da parada

        "nome": "Terminal Central",           // String - Nome do local

        "endereco": "Av. Central, 200",      // String - Endereço

        "coordenadas": GeoPoint,              // GeoPoint - Coordenadas

        "tempoParada": 10,                    // Number - Tempo de parada

        "observacoes": "Embarque de passageiros" // String - Observações

      }

    ]

  },

  // === PASSAGEIROS ===

  "passageiros": {

    "capacidadeMaxima": 20,                   // Number - Capacidade máxima

    "listaPassageiros": [

      {

        "nome": "Ana Costa",                  // String - Nome do passageiro

        "documento": "987.654.321-00",       // String - Documento
        
        "localizacao": GeoPoint,             // GeoPoint - Local do check-in

        "pontoEmbarque": "Terminal Central",  // String - Local de embarque

        "pontoDesembarque": "Hospital",       // String - Local de desembarque

        "necessidadesEspeciais": "Cadeirante" // String - Necessidades especiais

      }

    ]

  },

  // === CONTROLE DE EXECUÇÃO ===

  "checkIn": {

    "dataHora": Timestamp,                    // Timestamp - Momento do check-in

    "localizacao": GeoPoint,                  // GeoPoint - Local do check-in

    "observacoes": "Tudo normal",             // String - Observações

    "fotosVeiculo": ["url1", "url2"]          // Array - URLs das fotos

  },

  "checkOut": {

    "dataHora": Timestamp,                    // Timestamp - Momento do check-out

    "localizacao": GeoPoint,                  // GeoPoint - Local do check-out

    "observacoes": "Viagem concluída",       // String - Observações

    "quilometragemFinal": 45120               // Number - Quilometragem final

  },

  // === OCORRÊNCIAS ===

  "ocorrencias": [

    {

      "tipo": "atraso",                       // String - Tipo da ocorrência

      "descricao": "Trânsito intenso",        // String - Descrição

      "horario": Timestamp,                   // Timestamp - Momento da ocorrência

      "localizacao": GeoPoint,                // GeoPoint - Local da ocorrência

      "gravidade": "leve"                     // String - Gravidade: leve, media, grave

    }

  ],

  // === AVALIAÇÃO ===

  "ocorrencia_aluno": [{

    "nota": 4.5,                             // Number - Nota de 1 a 5

    "comentarios": "Viagem tranquila",       // String - Comentários

    "avaliadorTipo": "passageiro",           // String - Tipo do avaliador

    "dataAvaliacao": Timestamp               // Timestamp - Data da avaliação

  },
  
  ]

  // === METADADOS ===

  "criadaEm": Timestamp,                      // Timestamp - Data de criação

  "criadaPor": "sistema",                     // String - Quem criou

  "atualizadaEm": Timestamp,                  // Timestamp - Última atualização

  "canceladaEm": Timestamp,                   // Timestamp - Data cancelamento

  "motivoCancelamento": "Veículo quebrado"    // String - Motivo do cancelamento

}

```

  

### 🔗 Relacionamentos

- Referencia: `users` (motoristaId), `veiculos` (veiculoId), `rotas` (rotaId)

  

---

  

## 💰 Coleção: `despesas`

  

### 📄 Propósito

Registro de despesas dos motoristas (combustível, pedágios, etc.).

  

### 🔑 Estrutura do Documento

```javascript

{

  // === IDENTIFICAÇÃO ===

  "escalaId": "escala_001",                   // String - ID da escala relacionada

  // === CLASSIFICAÇÃO ===

  "categoria": "combustivel",                 // String - Categoria: combustivel, pedagio, estacionamento, manutencao, multa

  "descricao": "Abastecimento completo",      // String - Descrição da despesa

  // === VALORES ===

  "valor": 250.50,                           // Number - Valor da despesa

  "metodoPagamento": "cartao_credito",       // String - Método: dinheiro, cartao_debito, cartao_credito, pix

  // === TEMPORAL ===

  "dataCompra": Timestamp,                   // Timestamp - Data da compra

  "dataRegistro": Timestamp,                 // Timestamp - Data do registro no app

  "competencia": "2024-09",                  // String - Mês/ano de competência

  // === COMPROVANTES ===

  "comprovantes": [

    {
	  "nome": "Posto Shell Centro",           // String - Nome do estabelecimento
      
      "tipo": "nota_fiscal",                 // String - Tipo: nota_fiscal, cupom_fiscal, recibo
      
      "litros": "50",                        // Float
      
      "valor_litro": "100" ,                 // Float
      
      "arquivo": "https://example.com/nf.pdf", // String - URL do arquivo
    }

  ],

  // === CONTROLE DE APROVAÇÃO ===

  "status": "enviada",                      // String - Status: rascunho, enviada, aprovada, rejeitada, paga

  "aprovacao": {

    "aprovadaPor": "supervisor_001",        // String - ID do aprovador

    "dataAprovacao": Timestamp,             // Timestamp - Data da aprovação

    "observacoes": "Aprovada conforme"     // String - Observações

  },

  "rejeicao": {

    "rejeitadaPor": "supervisor_001",       // String - ID de quem rejeitou

    "dataRejeicao": Timestamp,              // Timestamp - Data da rejeição

    "motivo": "Comprovante ilegível",       // String - Motivo da rejeição

    "observacoes": "Reenviar documento"    // String - Observações

  },

  "reembolso": {

    "valorReembolsado": 250.50,             // Number - Valor reembolsado

    "dataReembolso": Timestamp,             // Timestamp - Data do reembolso

    "formaPagamento": "deposito_conta",     // String - Forma de pagamento

    "numeroComprovante": "PAG123456"       // String - Número do comprovante

  },

}

```

  

### 🔗 Relacionamentos

- Referencia:  `escalas` (escalaId)

  

---

  

## 🎫 Coleção: `chamados`

  

### 📄 Propósito

Sistema de chamados/suporte técnico.

  

### 🔑 Estrutura do Documento

```javascript

{

  // === IDENTIFICAÇÃO ===

  "numero": "CH001",                         // String - Número sequencial do chamado

  "motoristaId": "motorista_001",            // String - ID do motorista

  "veiculoId": "veiculo_001",                // String - ID do veículo (opcional)

  // === CLASSIFICAÇÃO ===

  "categoria": "manutencao",                 // String - Categoria: manutencao, tecnologia, administrativo, emergencia

  // === DESCRIÇÃO ===

  "descricao": "Freios fazendo ruído...",    // String - Descrição detalhada (motorista que faz)

  "impactoOperacional": "Veículo parado",    // String - Impacto na operação

  // === TEMPORAL ===

  "dataAbertura": Timestamp,                 // Timestamp - Data de abertura

  // === STATUS E ATENDIMENTO === 

  "status": "aberto",                        // String - Status: aberto, em_andamento, aguardando_peca, resolvido, fechado

  "atendente": {
    "id": "atendente_001",                   // String - ID do atendente
  },

  // === RESOLUÇÃO ===

  "solucao": {

    "descricao": "Substituídas pastilhas",   // String - Descrição da solução

    "pecasUtilizadas": ["pastilha_freio"],   // Array - Peças utilizadas

    "custoTotal": 150.00,                    // Number - Custo total

    "dataResolucao": Timestamp,              // Timestamp - Data da resolução

    "resolvidoPor": "tecnico_001"            // String - ID de quem resolveu

  },

  // === ARQUIVOS ANEXOS ===

  "anexos": [

    {

      "tipo": "foto",                        // String - Tipo: foto, video, documento, audio

      "arquivo": "https://example.com/foto.jpg", // String - URL do arquivo

      "adicionadoPor": "motorista_001",      // String - Quem adicionou

      "dataUpload": Timestamp                // Timestamp - Data do upload

    }

  ],
}

```

  

### 🔗 Relacionamentos

- Referencia: `users` (motoristaId), `veiculos` (veiculoId)

- Complementado por: `mensagensChamado`

  

---

## 📊 Coleção: `relatorios`

  

### 📄 Propósito

Relatórios mensais de atividades dos motoristas.

  

### 🔑 Estrutura do Documento

```javascript

{

  // === IDENTIFICAÇÃO ===

  "userId": "motorista_001",                // String - ID do usuário

  "periodo": "2024-09",                     // String - Período do relatório (YYYY-MM)

  // === DADOS DO RELATÓRIO ===

  "dados": {

    "escalasRealizadas": 22,                // Number - Número de escalas

    "horasTrabalho": 176,                   // Number - Horas trabalhadas

    "despesasTotais": 1250.75,              // Number - Total de despesas

    "chamadosAbertos": 1,                   // Number - Chamados abertos

    "notaAvaliacao": 4.5                    // Number - Nota média de avaliação

  },

  // === METADADOS ===

  "geradoEm": Timestamp                     // Timestamp - Data de geração

}

```

  

### 🔗 Relacionamentos

- Referencia: `users` (userId)

  

---

  

## 📈 Coleção: `metricas`

  

### 📄 Propósito

Métricas consolidadas dos motoristas.

  

### 🔑 Estrutura do Documento

```javascript

{

  // === MÉTRICAS GERAIS ===

  "escalasRealizadas": 250,                 // Number - Total de escalas

  "despesasTotais": 15000.50,               // Number - Total de despesas

  "chamadosAbertos": 1,                     // Number - Chamados em aberto

  "notaAvaliacao": 4.3,                     // Number - Nota média geral

  "tempoMedioViagem": 45,                   // Number - Tempo médio em minutos

  // === ÚLTIMA ATUALIZAÇÃO ===

  "atualizadoEm": Timestamp                 // Timestamp - Última atualização

}

```

  

---

  

## 🔐 Regras de Segurança

  

### Acesso aos Dados

- **Motoristas**: Acesso apenas aos próprios dados

- **Supervisores**: Acesso aos dados de sua equipe

- **Administradores**: Acesso completo

### Validações

- Campos obrigatórios validados no cliente e servidor

- Tipos de dados enforçados pelas regras do Firestore

- Relacionamentos validados antes da criação/atualização

  

---

  

## 📌 Índices Recomendados

  

### Consultas Frequentes

```javascript

// Escalas por motorista e data

escalas: motoristaId + dataEscala (desc)

  

// Despesas por motorista e status

despesas: motoristaId + status + dataRegistro (desc)

  

// Chamados por motorista e prioridade

chamados: motoristaId + status + prioridade + dataAbertura (desc)

  

// Notificações não lidas

notificacoes: lida + timestamp (desc)

```

  

---

  

## 🚀 Próximos Passos

  

1. **Implementar validações** no lado cliente (Flutter)

2. **Configurar índices** no Firebase Console

3. **Aplicar regras de segurança** no Firestore

4. **Implementar Cloud Functions** para automações

5. **Configurar backup** e políticas de retenção

---