# Relatório de Migração Arquitetural — Fase 1

**Projeto:** Edit Doc Flutter  
**Arquitetura:** MVVM (Model–View–ViewModel)  
**Escopo:** Login, Cadastro e Home/Lista; sem CRUD persistente.  

> **Nota de fidelidade:** o código original do DartPad não foi fornecido junto a esta versão de referência. O mapeamento abaixo corresponde às classes realmente presentes nesta implementação e demonstra onde as responsabilidades de um protótipo monolítico foram posicionadas. Antes da entrega acadêmica, compare com os nomes e recursos exatos do seu código DartPad e ajuste quaisquer diferenças. Não apresente a migração como idêntica sem essa conferência.

## 1. Mapeamento de classes, widgets e funções

| Responsabilidade anteriormente concentrada no DartPad | Classe/função nesta versão | Destino |
|---|---|---|
| Entrada e configuração da aplicação | `main()`, `EditDocApp` | `lib/main.dart` |
| Dados de cadastro e login | `Usuario` | `lib/models/usuario.dart` |
| Dados de um documento de demonstração | `Documento` | `lib/models/documento.dart` |
| Armazenamento temporário dos usuários | `BancoLocalService` | `lib/models/services/banco_local_service.dart` |
| Controle de login/cadastro, carregamento, erro e tema | `AuthViewModel` | `lib/viewmodels/auth_viewmodel.dart` |
| Exibição reativa da lista demonstrativa | `DocumentosViewModel` | `lib/viewmodels/documentos_viewmodel.dart` |
| Formulário de login | `LoginView` | `lib/views/login_view.dart` |
| Formulário de cadastro | `CadastroView` | `lib/views/cadastro_view.dart` |
| Home com lista de documentos de exemplo | `HomeView` | `lib/views/home_view.dart` |
| Validações de nome, e-mail e senha | `Validadores` | `lib/utils/validadores.dart` |
| Estrutura futura de preferências | `PreferencesService` (reservado) | `lib/models/services/preferences_service.dart` |
| Estrutura futura do editor | `EditorView` (reservado) | `lib/views/editor_view.dart` |

## 2. Alterações de estrutura e imports

- O arquivo único foi separado por responsabilidade: **Model** representa entidades e acesso a dados, **View** compõe widgets, **ViewModel** concentra estado e regras, e **utils** contém validações reutilizáveis.
- Cada classe pública passou a ser importada somente onde é usada, com imports relativos entre pastas e imports de `package:flutter/...` para widgets e `ChangeNotifier`.
- O construtor de `AuthViewModel` recebe `BancoLocalService`, permitindo substituir o armazenamento temporário pelo serviço persistente na Etapa 5 sem alterar os formulários.
- As telas recebem suas dependências por construtor (`required this.authViewModel` e `required this.documentosViewModel`). O `main.dart` instancia os ViewModels uma vez e os injeta nas telas.
- As rotas nomeadas em `MaterialApp` são `/` (Login), `/cadastro` (Cadastro) e `/home` (Home). A quarta rota `/editor` será adicionada na Fase 2.
- Os controladores `TextEditingController` e a `GlobalKey<FormState>` permanecem nas Views porque pertencem à interface, não às regras de negócio.

## 3. Gerenciamento de estado e comunicação reativa

- **Nenhum `setState()` é utilizado nas três Views.** Login e Cadastro não atualizam diretamente o estado de autenticação: chamam `entrar()` e `cadastrar()` do `AuthViewModel`.
- `AuthViewModel` herda de `ChangeNotifier` e guarda `_usuarioAtual`, `_carregando`, `_erro` e `_temaEscuro` com acesso externo por getters. `DocumentosViewModel` expõe a lista de demonstração de forma não modificável.
- Os métodos do ViewModel chamam `notifyListeners()` sempre que o estado muda. `ListenableBuilder` reconstrói os trechos relevantes do Login, Cadastro, Home e `MaterialApp`, inclusive ao alternar o tema.
- A navegação continua a cargo das Views com `Navigator.pushNamed`, `Navigator.pop` e `Navigator.pushNamedAndRemoveUntil`, enquanto a decisão de autenticar ou rejeitar o acesso pertence ao ViewModel.
- O `BancoLocalService` da Fase 1 mantém usuários apenas em memória. **Não existe persistência de cadastro, de sessão ou de documentos nesta entrega**; esses recursos integram a Etapa 5.

## 4. Evidências de homologação a registrar no Codespaces

Os testes abaixo devem ser efetivamente executados pelo estudante. Marque somente após confirmar o resultado:

- [ ] `flutter pub get` sem erros
- [ ] `flutter analyze` sem erros
- [ ] `flutter test` com os testes passando
- [ ] F5 abre preview na porta 8080
- [ ] Login → Cadastro → Login → Home → Sair
- [ ] Campos vazios, e-mail inválido e senha curta são rejeitados
- [ ] E-mail duplicado é rejeitado
- [ ] Tema alterna sem `setState` nas Views
- [ ] Commit e push da **Fase 1** realizados antes da Fase 2

**Observação:** a execução real no GitHub Codespaces não foi realizada nesta geração de arquivos. Inclua prints ou evidências reais após testar.
