# Edit Doc Flutter — Fase 1: arquitetura MVVM

Referência didática para a migração das três telas (**Login, Cadastro e Home/Lista**) para MVVM. Esta versão **ainda não contém CRUD persistente**; serve para o primeiro commit e a primeira entrega exigida pelo professor.

## Como montar no repositório do GitHub Codespaces

1. No GitHub, crie o repositório público `edit-doc-flutter`, marcando **Add a README file**.
2. **Antes de criar o Codespace**, adicione ao repositório os arquivos `.devcontainer/devcontainer.json` e `.vscode/launch.json` incluídos neste ZIP, usando o editor `github.dev`, e faça commit. Isso garante que o Codespace comece com a imagem que contém o Flutter SDK.
3. No GitHub, abra **Code → Codespaces → Create codespace on main**. No terminal do Codespace, execute `flutter create . --project-name edit_doc_flutter`.
4. Copie **todo o conteúdo deste ZIP** para a raiz do repositório, preservando as pastas ocultas `.devcontainer/` e `.vscode/` e substituindo arquivos de mesmo nome (sem substituir a pasta `.git/`). Se usar terminal, pode extrair o ZIP diretamente na raiz.
5. Execute `flutter pub get`, `flutter analyze` e `flutter test`.
6. Pressione F5 com **Rodar App Flutter (Web Preview)**; o servidor web será exposto na porta 8080.
7. Faça o teste: Cadastre um usuário (e-mail válido, senha com 6+ caracteres), volte e faça o login, confira a Home, o tema e o logout.
8. Confira e adapte `ARQUITETURA.md` ao código original do seu DartPad. Registre as evidências reais dos testes.
9. Execute os comandos abaixo e **entregue o link desta revisão no Blackboard antes de aplicar a Fase 2**.

```bash
git add .
git commit -m "Fase 1 - migracao MVVM e relatorio de arquitetura"
git push origin main
```

**Se o Codespace tiver sido criado antes dos arquivos `.devcontainer`, reconstrua o container (Command Palette → Dev Containers: Rebuild Container) ou crie um novo Codespace após o commit da configuração.**

**Importante:** os cadastros são temporários nesta Fase 1 e desaparecem ao reiniciar a página.

## Estrutura

`lib/main.dart` configura rotas e tema reativo. `lib/models` guarda entidades/serviços; `lib/viewmodels` concentra as regras e estado com `ChangeNotifier`; `lib/views` guarda os widgets; `lib/utils` centraliza validadores.

## Observação sobre a configuração de depuração

O enunciado usa `"args"` em `.vscode/launch.json`. O arquivo entregue usa `"toolArgs"` para encaminhar `-d web-server`, `--web-port` e `--web-hostname` à ferramenta Flutter, e não ao método `main()` da aplicação. Se o professor exigir a reprodução literal, confira com ele essa diferença técnica.

## Limitação da referência

Sem o código original do DartPad, não é possível assegurar equivalência visual e funcional exata com o protótipo já criado. A organização entregue funciona como base de referência a ser conferida/adaptada.
