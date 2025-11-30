# 📱 Habit Tracking App

## 📌 Descrição

Este projeto é um aplicativo mobile desenvolvido em **Flutter** para ajudar usuários a criar, acompanhar e manter hábitos saudáveis ao longo do tempo.  
Ele foi construído usando a arquitetura **MVVM**, integração com **Firebase** e conceitos de **gamificação**, com foco em organização de código e boa experiência de uso.

A aplicação demonstra funcionalidades comuns em apps de hábitos, como:

- Cadastro e autenticação de usuários  
- Criação e gerenciamento de hábitos diários  
- Acompanhamento visual do progresso com gráficos e calendário  
- Sistema de pontos, níveis e conquistas  
- Compartilhamento de conquistas com outras pessoas  

---

## ✅ Funcionalidades

- ✅ **Autenticação de Usuário**
  - Cadastro com e‑mail, senha e nome completo
  - Login e logout usando Firebase Authentication

- 📋 **Gestão de Hábitos**
  - Criação de novos hábitos com nome, descrição, frequência e horário
  - Listagem de “Meus Hábitos”
  - Marcar hábitos como concluídos por dia
  - Edição e exclusão de hábitos existentes

- 🔔 **Notificações Internas**
  - Criação de notificações quando um novo hábito é registrado
  - Listagem de notificações por usuário
  - Marcar uma ou todas como lidas
  - Contador de notificações não lidas no app

- 📊 **Progresso Visual**
  - Tela de Progresso com abas **Semana**, **Mês** e **Ano**
  - Gráficos representando hábitos concluídos ao longo do tempo
  - Calendário de dias concluídos para cada período
  - Estatísticas de taxa de conclusão e melhor sequência (best streak)
  - Para contas novas, gráficos, calendário e estatísticas iniciam zerados

- 🏆 **Gamificação**
  - Sistema de **pontos** e **níveis** salvo no Firestore (`users/{uid}/gamification/stats`)
  - Conquistas (`users/{uid}/achievements`) com pontos e status bloqueado/desbloqueado
  - Seções de “Conquistas Desbloqueadas” e “Próximas Conquistas”
  - Pontos, nível e conquistas começam zerados para novos usuários

- 📣 **Compartilhamento (Sharing)**
  - Tela de “Compartilhar Conquistas” com nome, foto, pontos, hábitos concluídos e sequência atual
  - Botões de compartilhamento rápido (progresso, conquistas, sequência, pontos) usando `share_plus`
  - Histórico de compartilhamentos salvo no campo `shareHistory` do usuário

---

## 🛠️ Tecnologias Utilizadas

- **Flutter** – Framework para desenvolvimento mobile multiplataforma
- **Dart** – Linguagem de programação do app
- **Provider** – Gerenciamento de estado (MVVM com `ChangeNotifier`)
- **Firebase Authentication** – Autenticação com e‑mail e senha
- **Cloud Firestore** – Banco de dados em nuvem para hábitos, notificações, gamificação e sharing
- **share_plus** – Biblioteca para compartilhamento nativo
- **Material Design** – Componentes visuais padrão do Flutter

---

## 📁 Estrutura do Projeto (MVVM)

```
lib/
├── core/
├── models/
│   ├── habit_model.dart           # Model de Hábito
│   ├── notification_model.dart    # Model de Notificação
│   └── achievement_model.dart     # Model de Conquista
│
├── viewmodels/
│   ├── register_viewmodel.dart        # Lógica de cadastro
│   ├── login_viewmodel.dart           # Lógica de login
│   ├── dashboard_viewmodel.dart       # Lógica da tela "Meus Hábitos"
│   ├── habit_creation_viewmodel.dart  # Criação de hábitos
│   ├── progress_viewmodel.dart        # Progresso visual (gráficos + calendário)
│   ├── gamification_viewmodel.dart    # Pontos, nível e conquistas
│   └── sharing_viewmodel.dart         # Tela de compartilhamento
│
├── views/
│   ├── auth/                  # Telas de Login e Cadastro
│   ├── dashboard/             # Tela principal "Meus Hábitos"
│   ├── progress/              # Tela de Progresso (Semana/Mês/Ano)
│   ├── gamification/          # Tela de Gamificação
│   └── sharing/               # Tela de Compartilhar Conquistas
│
├── services/
│   ├── auth_service.dart          # Integração com Firebase Auth
│   └── firestore_service.dart     # Acesso ao Cloud Firestore
│   └── notification_service.dart  # Agendamento e gerenciamento de notificações
│
├── repositories/
│   ├── habit_repository.dart          # Operações de hábito (via FirestoreService)
│   ├── notification_repository.dart   # Operações de notificação
│   ├── achievement_repository.dart    # Operações de gamificação/conquistas
│   └── sharing_repository.dart        # Operações da tela de compartilhamento
├── routes/
│   └── app_routes.dart           # Definição das rotas nomeadas do app
│
└── main.dart                    # Configuração do app, rotas e MultiProvider
```

---

## 🧩 Papel de cada camada

- **Model (models/)**  
  - Representa os dados da aplicação (ex.: `Habit`, `HabitNotification`, `Achievement`).
  - Contém apenas estrutura de dados e conversões `fromJson`/`toJson`.

- **View (views/)**  
  - Telas e widgets que o usuário vê: layout, textos, botões, gráficos.  
  - Não fazem chamadas diretas ao Firebase; apenas exibem dados vindos do ViewModel e disparam ações (onTap, onPressed).

- **ViewModel (viewmodels/)**  
  - Contêm a lógica da tela, estado e comunicação com `repositories`/`services`.  
  - Exemplo: carregar hábitos, criar hábito, buscar pontos, conquistas, progresso.  
  - Estendem `ChangeNotifier` e chamam `notifyListeners()` para atualizar a interface quando algo muda.

---

## 🔗 Comunicação entre View e ViewModel

- No `main.dart`, os ViewModels são registrados com `MultiProvider` e `ChangeNotifierProvider`.
- As Views acessam o ViewModel usando:
  - `context.read<MeuViewModel>()` para chamar métodos (ex.: `loadHabits()`, `createHabit()`).
  - `Consumer<MeuViewModel>` ou `context.watch<MeuViewModel>()` para reconstruir a UI quando o estado muda.
- Fluxo típico:
  1. A View chama um método do ViewModel (por exemplo, no `initState` ou ao apertar um botão).
  2. O ViewModel chama o `Repository`, que usa o `FirestoreService` para ler/escrever no Firebase.
  3. O ViewModel atualiza suas variáveis internas e chama `notifyListeners()`.
  4. O `Consumer` na View reconstrói a interface automaticamente com os novos dados.

---

## ▶️ Como Executar o Projeto

### 🔧 Pré-requisitos

- Flutter SDK instalado (versão estável)
- Dart (incluso com Flutter)
- Conta Firebase configurada com:
  - **Authentication** (Email/Password)
  - **Cloud Firestore** habilitado
- Emulador Android/iOS ou dispositivo físico

### 🚀 Passos

1. **Clone o repositório**
2. **Instale as dependências:**
  - flutter pub get
3. **Configure o Firebase:**
  - Adicione o arquivo `google-services.json` (Android) na pasta `android/app`.
  - Adicione o arquivo `GoogleService-Info.plist` (iOS) na pasta `ios/Runner`.
  - No console do Firebase, habilite Authentication (Email/Password) e Cloud Firestore.
4. **Execute o app:**
  - flutter run
