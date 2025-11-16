# GalleryApp
## Project Setup

### 1.1 — Инициализация проекта
- Создан новый Xcode‑проект **GalleryApp**.
- Базовая структура включает `AppDelegate.swift`, `SceneDelegate.swift` и стартовый `ViewController.swift`.
- Добавлен `.gitignore` для исключения временных файлов и артефактов сборки.

### 1.2 — Настройка Git
- Репозиторий инициализирован локально.
- Подключён удалённый origin на GitHub.
- Принята схема ветвления:
  - `main` — стабильные релизы.
  - `develop` — основная ветка разработки.
  - `feature/*` — отдельные ветки для задач.

### 1.3 — Настройка SwiftLint
- Установлен SwiftLint через Homebrew:
  ```bash
  brew install swiftlint

## Development Setup

### 1.4 Pre-commit Hook (SwiftLint)

В проекте настроен Git pre-commit hook, который запускает **SwiftLint** перед каждым коммитом.  
- Если есть ошибки уровня *error* — коммит блокируется.  
- Если только *warnings* — коммит проходит, но выводятся предупреждения.  

Хук находится в `.git/hooks/pre-commit` и автоматически проверяет все закоммиченные `.swift` файлы.  
Это гарантирует единый стиль кода и чистую историю в репозитории.

## Configuration

### Unsplash API Setup

Для работы приложения необходим API ключ от Unsplash:

1. Зарегистрируйтесь на https://unsplash.com/developers
2. Создайте приложение и получите Access Key
3. Скопируйте `Config.xcconfig.example` в `Config.xcconfig` (в папке `Resources/`)
4. Замените `your_access_key_here` на ваш реальный ключ
5. Убедитесь, что `Config.xcconfig` добавлен в `.gitignore` (уже настроено)

**Важно**: Никогда не коммитьте `Config.xcconfig` с реальным ключом в Git!

## Шаг 1.5 — Менеджер зависимостей (Swift Package Manager)

### Что делаем
Настраиваем **Swift Package Manager (SPM)** для управления модулями и внешними библиотеками.  
SPM встроен в Xcode, не требует отдельной установки (в отличие от CocoaPods) и используется для подключения библиотек и создания модулей.

### Подробные действия
1. **Создание папки для локальных пакетов**
   ```bash
   mkdir Packages
