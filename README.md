# Edit Doc Flutter — Fase 2: CRUD e persistência local

Aplicação didática Flutter Web que implementa **Model–View–ViewModel (MVVM)** com quatro telas: Login (`/`), Cadastro (`/cadastro`), Home/Lista (`/home`) e Editor (`/editor`).

## Execução no GitHub Codespaces

**Pré-requisito acadêmico:** envie e registre o commit da **Fase 1** com seu `ARQUITETURA.md` antes de aplicar a Fase 2.

1. No Codespace do repositório `edit-doc-flutter`, use a mesma branch `main`.
2. Use o Codespace já criado com a configuração `.devcontainer` da Fase 1. Se ainda não gerou a infraestrutura Flutter, execute `flutter create . --project-name edit_doc_flutter`.
3. Extraia este ZIP **sobre a versão da Fase 1**, substituindo os arquivos de mesmo nome e preservando a pasta `.git/` do repositório.
4. Execute `flutter pub get`, `flutter analyze` e `flutter test`.
5. Pressione F5 para abrir o servidor web na porta 8080 (configuração de `.vscode/launch.json`).
6. Cadastre-se, faça login, crie um documento, edite-o, exclua outro documento, alterne o tema e recarregue o preview para confirmar a persistência.
7. Faça o commit e push da Fase 2:

```bash
git add .
git commit -m "Fase 2 - CRUD de documentos e persistencia local"
git push origin main
```

## Arquitetura

- **Model:** `Usuario`, `Documento` e seus métodos de serialização JSON.
- **Services:** `BancoLocalService` (usuários), `PreferencesService` (tema/sessão) e `DocumentoStorageService` (CRUD dos documentos). Todos os dados persistentes são locais ao navegador via `shared_preferences`.
- **ViewModel:** `AuthViewModel` e `DocumentosViewModel`, ambos com `ChangeNotifier`, regras e estados encapsulados.
- **View:** telas de Login, Cadastro, Home e Editor, que usam `ListenableBuilder` e chamam o ViewModel, sem `setState()`.
- **Utils:** `Validadores` centraliza validações.

## Quadro de testes manuais (registre evidências reais)

- [ ] Cadastro com nome/e-mail/senha válidos
- [ ] Rejeição de cadastro duplicado, e-mail inválido e senha curta
- [ ] Login correto, login incorreto e sair
- [ ] Criar documento e aparecer na lista
- [ ] Abrir, editar e salvar documento
- [ ] Excluir documento com confirmação
- [ ] Recarregar a página e manter documentos e sessão
- [ ] Recarregar a página e manter tema claro/escuro
- [ ] Entrar com segundo usuário e não enxergar documentos do primeiro
- [ ] `flutter analyze` sem erros
- [ ] `flutter test` com testes aprovados

## Limitações e segurança

`shared_preferences` no alvo Web utiliza armazenamento do navegador, não um banco remoto: os dados não são sincronizados entre dispositivos nem protegidos contra usuários que tenham acesso ao perfil/navegador. O protótipo guarda contas localmente com SHA-256 e sal aleatório, apenas com finalidade didática. **Isso não constitui autenticação segura**: para uma aplicação real, use backend, autenticação no servidor, armazenamento seguro, hash de senha apropriado (Argon2id/bcrypt/scrypt) e medidas de autorização. Não utilize senhas reais nem documentos sensíveis neste protótipo.

O arquivo `.vscode/launch.json` usa `toolArgs` para passar parâmetros ao comando Flutter. O enunciado traz `args`, mas essa opção costuma encaminhar parâmetros à aplicação em vez de configurar `flutter run`.

**Ao concluir:** visite https://github.com/codespaces, selecione o Codespace e use **Stop** para não consumir horas desnecessárias.
