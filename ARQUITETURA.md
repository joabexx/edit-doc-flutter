# Relatório de Migração Arquitetural — Fase 1

Este relatório descreve **o primeiro marco entregue**. Mantê-lo no repositório da Fase 2 permite comprovar a sequência exigida pelo professor, mas a comprovação final depende do histórico real de commits do GitHub.

> O código monolítico original do DartPad não foi fornecido para comparação. O mapeamento documenta a implementação de referência da Fase 1. Ajuste descrições caso o código original tenha nomes ou comportamentos diferentes.

## 1. Mapeamento das responsabilidades

| Elemento | Fase 1: localização MVVM |
|---|---|
| Inicialização, `EditDocApp`, tema e rotas | `lib/main.dart` |
| `Usuario` | `lib/models/usuario.dart` |
| `Documento` (exemplo de leitura) | `lib/models/documento.dart` |
| `BancoLocalService` (usuarios em memória) | `lib/models/services/banco_local_service.dart` |
| `AuthViewModel` (login, cadastro, tema, sessão em memória) | `lib/viewmodels/auth_viewmodel.dart` |
| `DocumentosViewModel` (lista demonstrativa) | `lib/viewmodels/documentos_viewmodel.dart` |
| `LoginView` | `lib/views/login_view.dart` |
| `CadastroView` | `lib/views/cadastro_view.dart` |
| `HomeView` | `lib/views/home_view.dart` |
| `Validadores` (nome, e-mail, senha) | `lib/utils/validadores.dart` |
| `PreferencesService` e `EditorView` | Reservados para a Etapa 5 |

## 2. Adaptações e imports

O código foi organizado em camadas com imports relativos entre arquivos `lib/`. Os construtores das telas recebem ViewModels e `AuthViewModel` recebe o serviço de usuários. As classes passaram a possuir responsabilidades definidas, getters públicos e estado privado. As rotas nomeadas `/`, `/cadastro` e `/home` foram configuradas no `MaterialApp` da Fase 1. Os validadores foram extraídos para `lib/utils/validadores.dart`. `TextEditingController` e `GlobalKey<FormState>` permanecem nas Views, pois são detalhes da interface.

## 3. Estado antes do CRUD

Não há `setState()` nas Views. `AuthViewModel extends ChangeNotifier` mantém `_usuarioAtual`, `_carregando`, `_erro` e `_temaEscuro`; `DocumentosViewModel` expõe dados da lista demonstrativa. Os ViewModels chamam `notifyListeners()` e as Views usam `ListenableBuilder`. O `main.dart` também ouve o ViewModel para atualizar `ThemeMode`.

## 4. Extensões posteriores (Fase 2)

**Somente depois do commit da Fase 1:** `BancoLocalService` passou a persistir contas no navegador, `PreferencesService` passou a gravar tema e sessão, `DocumentoStorageService` foi criado para serialização JSON e CRUD; `DocumentosViewModel` passou a gerenciar lista e operações assíncronas; `EditorView` foi implementada e a rota `/editor` adicionada.

## 5. Evidências

- [ ] Registrar hash/link do commit da Fase 1
- [ ] Registrar prints do F5 e dos três formulários/navegação
- [ ] Registrar resultado do `flutter analyze` e `flutter test`
- [ ] Registrar segundo commit com CRUD e persistência

Não há alegação de testes executados no Codespaces sem a execução real.
