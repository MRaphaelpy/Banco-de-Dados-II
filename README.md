# SINATRANS - Disciplina de Banco de dados II

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Estrutura do Banco de Dados](#estrutura-do-banco-de-dados)
- [Módulos do Sistema](#módulos-do-sistema)
- [Relacionamentos Principais](#relacionamentos-principais)
- [Considerações Técnicas](#considerações-técnicas)

---

## 🎯 Visão Geral

O **SINATRANS** é um sistema completo e integrado para gestão de transporte público e logística, desenvolvido para atender empresas de transporte de passageiros e cargas. O sistema contempla desde o gerenciamento de frotas e recursos humanos até o controle financeiro e monitoramento em tempo real.

### Principais Funcionalidades:

- ✅ Gestão completa de pessoas (passageiros, funcionários, motoristas)
- ✅ Controle de frota e manutenção de veículos
- ✅ Operação de transporte (linhas, rotas, escalas, viagens)
- ✅ Logística e gestão de cargas
- ✅ Monitoramento GPS e segurança
- ✅ Controle de qualidade e satisfação
- ✅ Gestão administrativa e financeira
- ✅ Recursos humanos completo
- ✅ Sistema de bilhetagem eletrônica
- ✅ Gestão de terminais e pontos turísticos

---

## 📊 Estrutura do Banco de Dados

O banco de dados está organizado em **10 arquivos SQL modulares**, facilitando a manutenção e evolução do sistema:

```
CodigosSql/
├── 00_banco.sql                              # Criação do banco SINATRANS
├── 01_gestao_pessoas.sql                     # Módulo de Gestão de Pessoas
├── 02_veiculos_frota.sql                     # Módulo de Veículos e Frota
├── 03_operacao_transporte.sql                # Módulo de Operação de Transporte
├── 04_logistica_cargas.sql                   # Módulo de Logística e Cargas
├── 05_monitoramento_seguranca.sql            # Módulo de Monitoramento e Segurança
├── 06_controle_qualidade.sql                 # Módulo de Controle de Qualidade
├── 07_gestao_operacoes.sql                   # Módulo de Gestão de Operações
├── 08_gestao_administrativa_financeira.sql   # Módulo Administrativo/Financeiro
├── 09_recursos_humanos.sql                   # Módulo de Recursos Humanos
└── 10_outros_modulos.sql                     # Módulo de Sistema e Utilidades
```

---

## 🔧 Módulos do Sistema

### 1️⃣ Gestão de Pessoas (01_gestao_pessoas.sql)

**Propósito:** Gerenciar todos os cadastros de pessoas relacionadas ao sistema.

**Tabelas principais:**
- `passageiro` - Cadastro de passageiros com tipos diferenciados
- `passageiro_estudante` - Informações específicas de estudantes
- `passageiro_pcd` - Informações de pessoas com deficiência
- `passageiro_idoso` - Informações de idosos
- `funcionario` - Cadastro geral de funcionários
- `motorista` - Informações específicas de motoristas
- `cobrador` - Informações específicas de cobradores
- `endereco` - Endereços completos com coordenadas
- `cargo` - Cargos da empresa
- `departamento` - Departamentos organizacionais
- `escala_trabalho` - Escalas de trabalho (6x1, 5x2, 12x36, etc.)

**Recursos:**
- Biometria digital e facial
- Tipos de passageiros (Regular, Estudante, Idoso, PCD)
- Estrutura organizacional completa
- Geolocalização de endereços

---

### 2️⃣ Veículos e Frota (02_veiculos_frota.sql)

**Propósito:** Gerenciar toda a frota de veículos e manutenções.

**Tabelas principais:**
- `veiculo` - Cadastro completo de veículos
- `modelo_veiculo` - Modelos e especificações técnicas
- `garagem` - Garagens e bases operacionais
- `manutencao` - Registro de manutenções (preventiva, corretiva)
- `peca` - Catálogo de peças
- `estoque_peca` - Controle de estoque de peças
- `movimentacao_estoque` - Movimentações de entrada/saída
- `servico_manutencao` - Catálogo de serviços
- `abastecimento` - Registro de abastecimentos
- `posto_abastecimento` - Postos conveniados
- `pneu` - Controle individual de pneus
- `posicao_pneu` - Posicionamento de pneus nos veículos
- `historico_calibragem` - Histórico de calibragens

**Recursos:**
- Suporte a múltiplos tipos de combustível
- Controle de quilometragem e consumo
- Gestão de vida útil de pneus
- Rastreamento de custos de manutenção
- Gestão de garantias de peças

---

### 3️⃣ Operação de Transporte (03_operacao_transporte.sql)

**Propósito:** Gerenciar linhas, rotas, horários e operação de transporte de passageiros.

**Tabelas principais:**
- `linha_transporte` - Linhas de transporte (urbana, intermunicipal, etc.)
- `rota` - Rotas detalhadas (ida, volta, circular)
- `parada` - Pontos de parada e estações
- `parada_rota` - Associação de paradas às rotas
- `horario` - Grade horária de operação
- `horario_parada` - Horários previstos em cada parada
- `tarifa` - Tarifas e descontos por tipo
- `cartao_bilhetagem` - Cartões de passageiros
- `recarga` - Recargas de cartões
- `utilizacao_cartao` - Uso de cartões (validações)
- `validador` - Validadores eletrônicos
- `escala` - Escalas de motoristas e veículos
- `viagem` - Viagens realizadas
- `ponto_viagem` - Controle de passagem por pontos
- `controle_ocupacao` - Monitoramento de lotação
- `empresa_operadora` - Empresas operadoras
- `consorcio` - Consórcios de transporte

**Recursos:**
- Sistema completo de bilhetagem eletrônica
- Controle de integração temporal
- Múltiplos tipos de tarifas
- Monitoramento de ocupação em tempo real
- Gestão de consórcios e empresas operadoras

---

### 4️⃣ Logística e Cargas (04_logistica_cargas.sql)

**Propósito:** Gerenciar transporte de cargas e logística.

**Tabelas principais:**
- `cliente` - Clientes (pessoa física/jurídica)
- `tipo_carga` - Tipos de carga com características
- `carga` - Cargas registradas
- `volume` - Volumes individuais de carga
- `ordem_transporte` - Ordens de transporte
- `item_ordem_transporte` - Itens das ordens
- `rota_carga` - Rotas de transporte de carga
- `trecho_rota_carga` - Trechos detalhados das rotas
- `operacao_carga` - Operações de transporte executadas
- `ocorrencia_operacao` - Ocorrências durante operações

**Recursos:**
- Suporte a cargas perigosas e especiais
- Controle de temperatura para cargas refrigeradas
- Rastreamento de volumes por código de barras
- Gestão completa de rotas e trechos
- Registro de ocorrências e custos operacionais

---

### 5️⃣ Monitoramento e Segurança (05_monitoramento_seguranca.sql)

**Propósito:** Monitorar veículos em tempo real e gerenciar segurança.

**Tabelas principais:**
- `veiculo_gps` - Dispositivos GPS instalados
- `rastreamento_gps` - Dados de rastreamento em tempo real
- `evento_gps` - Eventos especiais detectados
- `cerca_eletronica` - Cercas eletrônicas configuradas
- `veiculo_cerca` - Associação de veículos às cercas
- `camera` - Câmeras de segurança
- `gravacao` - Gravações de vídeo
- `incidente_seguranca` - Incidentes registrados
- `ocorrencia_veiculo` - Ocorrências operacionais

**Recursos:**
- Rastreamento GPS em tempo real
- Detecção de eventos (excesso de velocidade, desvio de rota, botão de pânico)
- Cercas eletrônicas com alertas
- Sistema de câmeras com gravação
- Registro completo de incidentes de segurança
- Integração com boletins de ocorrência

---

### 6️⃣ Controle de Qualidade (06_controle_qualidade.sql)

**Propósito:** Avaliar e monitorar a qualidade dos serviços prestados.

**Tabelas principais:**
- `indicador_desempenho` - KPIs do sistema
- `medicao_indicador` - Medições periódicas de indicadores
- `pesquisa_satisfacao` - Pesquisas de satisfação
- `questao_pesquisa` - Questões das pesquisas
- `resposta_pesquisa` - Respostas coletadas
- `detalhe_resposta_pesquisa` - Detalhes das respostas
- `reclamacao_sugestao` - Manifestações de usuários
- `acompanhamento_manifestacao` - Acompanhamento de manifestações
- `auditoria_interna` - Auditorias realizadas
- `nao_conformidade` - Não conformidades identificadas
- `acao_corretiva_preventiva` - Ações corretivas/preventivas

**Recursos:**
- Sistema completo de KPIs
- Múltiplos tipos de pesquisas de satisfação
- Gestão de reclamações, sugestões e elogios
- Sistema de auditorias internas
- Controle de não conformidades e ações corretivas
- Avaliação de eficácia das ações

---

### 7️⃣ Gestão de Operações (07_gestao_operacoes.sql)

**Propósito:** Gerenciar terminais, turismo e eventos especiais.

**Tabelas principais:**
- `terminal` - Terminais e estações
- `integracao_modal` - Integrações entre modais
- `area_aluguel_terminal` - Áreas comerciais em terminais
- `guia_turistico` - Guias turísticos cadastrados
- `roteiro_turistico` - Roteiros turísticos
- `excursao` - Excursões agendadas
- `participante_excursao` - Participantes de excursões
- `ponto_turistico` - Pontos turísticos cadastrados
- `ponto_roteiro` - Pontos nos roteiros
- `evento_especial` - Eventos que impactam operação
- `planejamento_evento` - Planejamento operacional para eventos

**Recursos:**
- Gestão multimodal (ônibus, metrô, trem, VLT, etc.)
- Sistema completo de turismo
- Gestão de áreas comerciais em terminais
- Planejamento para eventos especiais
- Múltiplos idiomas para guias turísticos

---

### 8️⃣ Gestão Administrativa e Financeira (08_gestao_administrativa_financeira.sql)

**Propósito:** Gerenciar toda área administrativa e financeira da empresa.

**Tabelas principais:**
- `fornecedor` - Cadastro de fornecedores
- `contrato` - Contratos da empresa
- `aditivo_contratual` - Aditivos de contratos
- `ordem_compra` - Ordens de compra
- `item_ordem_compra` - Itens das ordens
- `nota_fiscal` - Notas fiscais (entrada/saída)
- `item_nota_fiscal` - Itens das notas
- `conta_pagar` - Contas a pagar
- `conta_receber` - Contas a receber
- `folha_pagamento` - Folhas de pagamento
- `pagamento_funcionario` - Pagamentos individuais
- `centro_custo` - Centros de custo
- `plano_contas` - Plano de contas contábil
- `movimentacao_contabil` - Lançamentos contábeis
- `orcamento` - Orçamentos por centro de custo

**Recursos:**
- Gestão completa de compras e fornecedores
- Controle de contratos e aditivos
- Sistema de contas a pagar e receber
- Folha de pagamento completa
- Contabilidade com plano de contas
- Orçamento x Realizado
- Múltiplos centros de custo

---

### 9️⃣ Recursos Humanos (09_recursos_humanos.sql)

**Propósito:** Gerenciar recursos humanos de forma completa.

**Tabelas principais:**
- `treinamento` - Treinamentos oferecidos
- `participante_treinamento` - Participantes em treinamentos
- `exame_medico` - Exames médicos ocupacionais
- `documento_funcionario` - Documentos dos funcionários
- `dependente` - Dependentes de funcionários
- `habilidade_funcionario` - Habilidades e competências
- `ferias` - Controle de férias
- `advertencia_suspensao` - Advertências e suspensões
- `avaliacao_desempenho` - Avaliações de desempenho
- `requisicao_pessoal` - Requisições de novas contratações

**Recursos:**
- Gestão completa de treinamentos
- Medicina e segurança do trabalho
- Gestão documental de funcionários
- Controle de férias e benefícios
- Sistema de avaliação de desempenho
- Processo de recrutamento e seleção
- Banco de habilidades

---

### 🔟 Sistema e Utilidades (10_outros_modulos.sql)

**Propósito:** Módulos de sistema, segurança e configuração.

**Tabelas principais:**
- `usuario` - Usuários do sistema
- `perfil_acesso` - Perfis de acesso
- `permissao` - Permissões do sistema
- `permissao_perfil` - Associação de permissões a perfis
- `log_sistema` - Logs de auditoria
- `configuracao_sistema` - Configurações do sistema
- `notificacao` - Sistema de notificações
- `documento_sistema` - Documentos e manuais
- `relatorio_salvo` - Relatórios salvos/agendados
- `alerta_programado` - Alertas automáticos

**Recursos:**
- Sistema completo de autenticação e autorização
- Controle de permissões granular
- Auditoria completa de operações
- Sistema de notificações
- Gestão documental do sistema
- Agendamento de relatórios
- Alertas automáticos configuráveis

---


## 🔗 Relacionamentos Principais

### Diagrama de Relacionamentos (Principais entidades) (ainda falta terminar)

```
passageiro (1) ──→ (N) cartao_bilhetagem
    ↓
    └──→ (1) passageiro_estudante
    └──→ (1) passageiro_pcd
    └──→ (1) passageiro_idoso

funcionario (1) ──→ (1) motorista
           └──→ (1) cobrador
           └──→ (N) viagem

veiculo (1) ──→ (N) viagem
        └──→ (N) manutencao
        └──→ (N) abastecimento
        └──→ (1) veiculo_gps

linha_transporte (1) ──→ (N) rota
                 └──→ (N) tarifa

rota (1) ──→ (N) parada_rota ←── (N) parada
     └──→ (N) horario
     └──→ (N) viagem

viagem (1) ──→ (N) ponto_viagem
       └──→ (N) controle_ocupacao

ordem_transporte (1) ──→ (N) item_ordem_transporte ←── (N) carga

cliente (1) ──→ (N) ordem_transporte
        └──→ (N) carga
```

### Relacionamentos Chave por Módulo

**Gestão de Pessoas:**
- Passageiro → Passageiro_Detalhe (1:1)
- Passageiro → Passageiro_Estudante/PCD/Idoso (1:1 opcional)
- Funcionário → Motorista/Cobrador (1:1 especialização)
- Funcionário → Cargo/Departamento (N:1)
- Funcionario → escala_trabalho (1:1)

**Veículos:**
- Veículo → Modelo_Veiculo (N:1)
- Veículo → Manutenção (1:N)
- Veiculo → Garagem (1:1) opcional (onibus, vans, etc)
- Manutenção → Item_Manutencao (1:N)
- Item_Manutencao → Peça/Serviço (N:1)
- 

**Operação:**
- Linha → Rota (1:N)
- Rota → Parada_Rota → Parada (N:N)
- Viagem → Veiculo + Motorista + Rota (N:1)
- Cartao_Bilhetagem → Utilizacao_Cartao (1:N)
- Cartao_Bilhetagem → tarifa (1:N)
- Cartao_Bilhetagem → recarga (1:N)
- viagem → escala (1:N)
- Viagem → ponto_viagem (1:N)

**Logística e Cargas**
- Cliente → ordem_transporte (1:N)
- ordem_transporte → itens_ordem_transporte (1:N)
- itens_ordem_transporte → carga (1:1)
- carga → tipo_carga (1:1) 
- carga → volume(1:1)

**Monitoramento e segurança**
- veiculo_gps → rastreamento_gps(1:N)
- veiculo_cerca → cerca_eletronica (1:N)
- camera → gravaçao (1:N)
- gravaçao → incidente_segurança (N:N)
- 
**controle de qualidade**
- pesquisa_satisfacao → questao_pesquisa (1:N)
- questao_pesquisa → resposta_pesquisa (1:1)
- respota_pesquisa → detalhe_resposta_pesquisa (1:1)
- 
- 
**Gestao de operaçoes**
- 
```bash# Puxe a imagem oficial do MySQL
docker pull mysql:latest            
# Inicie um contêiner MySQL
docker run --name meu-mysql -e MYSQL_ROOT_PASSWORD=minha_senha -p 3306:3306 -d mysql:latest
# Acesse o contêiner
docker exec -it meu-mysql bash
# Conecte ao MySQL
mysql -u root -p
# Digite a senha definida (minha_senha)
```
# Crie o banco
```sql
CREATE DATABASE SINATRANS;
USE SINATRANS;
```
# Execute os scripts SQL na ordem
```sql
source /caminho/para/CodigosSql/00_banco.sql;
source /caminho/para/CodigosSql/01_gestao_pessoas.sql;
source /caminho/para/CodigosSql/02_veiculos_frota.sql;
source /caminho/para/CodigosSql/03_operacao_transporte.sql
e por ai vai né;     
