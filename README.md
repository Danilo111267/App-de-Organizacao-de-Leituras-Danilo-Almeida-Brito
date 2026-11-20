# App de Organização de Leituras

Projeto Flutter/Dart desenvolvido por Danilo Almeida Brito.

## Executar

Abra a pasta no VS Code e, com o Flutter instalado, execute:

```bash
flutter create . --project-name organizacao_leituras --platforms=android,web
flutter pub get
flutter run -d chrome
```

O primeiro comando garante que os arquivos de plataforma do Flutter estejam completos para a versão do SDK instalada.

Os livros são salvos localmente com `shared_preferences`, em uma lista JSON armazenada sob a chave `livros`.
