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
   ```

---

## Фаза 2: Модульная архитектура и сетевой слой ✅

### Созданные модули

#### ✅ Core Module
Базовые утилиты и расширения для UI:
- `UIView+Extensions` - удобное добавление нескольких subviews
- `UIImageView+Extensions` - заготовка для загрузки изображений (будет использован Kingfisher)
- `Config` - безопасный доступ к конфигурации приложения (API ключи)

**Зависимости**: нет

#### ✅ Models Module
Модели данных для Unsplash API:
- `UnsplashPhoto` - основная модель фотографии с Codable
- `PhotoURLs` - структура URL для разных размеров изображений
- `User` - информация об авторе фотографии

**Зависимости**: нет

#### ✅ NetworkLayer Module
Сетевой слой для работы с API:
- `NetworkService` - протокол для абстракции сетевых запросов
- `URLSessionNetworkService` - реализация на базе URLSession
- `Endpoint` - структура для построения API запросов
- `NetworkError` - enum с типами ошибок
- `UnsplashService` - специализированный сервис для Unsplash API

**Зависимости**: Models, Core

### Архитектура модулей

```
GalleryApp
  ├── Core (базовые утилиты)
  │   ├── UIView+Extensions
  │   ├── UIImageView+Extensions
  │   └── Config
  ├── Models (модели данных)
  │   └── UnsplashPhoto, PhotoURLs, User
  └── NetworkLayer (сетевой слой)
      ├── NetworkService (протокол)
      ├── URLSessionNetworkService (реализация)
      ├── Endpoint (построение запросов)
      └── UnsplashService (специализированный сервис)
```

### Тестирование

#### Unit-тесты
- `UnsplashServiceTests` - тесты для UnsplashService
- `MockNetworkService` - mock-объект для изоляции тестов
- Все тесты проходят успешно ✅

#### Как работают тесты
- **Mock** - это объект-заглушка, который имитирует реальный NetworkService
- **Unit-тесты** - проверяют код (UnsplashService), который работает с mock-объектом
- Тесты изолированы от реальных сетевых запросов

### Технические детали

- **Платформа**: iOS 15+
- **Swift**: 5.9+
- **Архитектура**: MVVM + Clean Architecture
- **Модульность**: Swift Package Manager (SPM)
- **Сетевые запросы**: Async/await
- **Декодирование**: Codable с поддержкой snake_case

### Использование

```swift
import NetworkLayer
import Core
import Models

// Создание сервиса
let networkService = URLSessionNetworkService(accessKey: Config.unsplashAccessKey)
let unsplashService = UnsplashService(networkService: networkService)

// Получение фотографий
let photos = try await unsplashService.fetchPhotos(page: 1, perPage: 30)
```

### Статус проекта

- ✅ Все модули компилируются без ошибок
- ✅ SwiftLint проходит без нарушений
- ✅ Unit-тесты написаны и проходят
- ✅ Конфигурация API ключа работает корректно
- ✅ Модули подключены к основному проекту
- ✅ Тесты запускаются на симуляторе

### Следующие шаги

- [ ] Создание DataLayer модуля
- [ ] Создание GalleryFeature модуля
- [ ] Создание DetailFeature модуля
- [ ] Интеграция всех модулей в единое приложение
