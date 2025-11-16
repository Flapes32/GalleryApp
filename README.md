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

## Фаза 2: Создание модулей и сетевого слоя

### Шаг 2.1: Создание модуля Core

**Что делаем**: Создаем первый Swift Package для базовых утилит и расширений.

**Подробные действия**:

1. **Создание пакета через Xcode**:
   - File → New → Package
   - Шаблон: Library
   - Название: `Core`
   - Место сохранения: папка `Packages/`

2. **Настройка Package.swift**:
   - Платформа: iOS 15+
   - Swift version: 5.9
   - Настроены products и targets

3. **Создание базовых расширений**:
   - `UIView+Extensions.swift` - метод `addSubviews(_:)` для удобного добавления нескольких subviews
   - `UIImageView+Extensions.swift` - заготовка метода `setImage(from:placeholder:)` для загрузки изображений (позже будет использован Kingfisher)

4. **Подключение модуля к проекту**:
   - Модуль Core добавлен в Frameworks, Libraries, and Embedded Content
   - Подключён к target GalleryApp

**Результат**: Модуль Core создан и подключен к проекту.

---

### Шаг 2.2: Создание модуля Models

**Что делаем**: Создаем модуль для общих моделей данных.

**Подробные действия**:

1. **Создание пакета Models**:
   - File → New → Package
   - Название: `Models`
   - Сохранён в `Packages/`

2. **Создание модели UnsplashPhoto**:
   - `UnsplashPhoto.swift` - основная модель фотографии
   - `PhotoURLs` - структура URL для разных размеров изображений (raw, full, regular, small, thumb)
   - `User` - информация об авторе фотографии
   - Все модели реализуют `Codable` для JSON декодирования
   - Используется `CodingKeys` для маппинга snake_case JSON полей

3. **Подключение Models к проекту**:
   - Модуль Models добавлен в Frameworks
   - Подключён к target GalleryApp

**Результат**: Модуль Models создан с моделями для Unsplash API.

---

### Шаг 2.3: Регистрация в Unsplash API

**Что делаем**: Получаем API ключ для доступа к Unsplash.

**Подробные действия**:

1. **Регистрация на Unsplash**:
   - Переход на https://unsplash.com/developers
   - Регистрация как разработчик
   - Создание приложения "iOS Gallery Test App"

2. **Создание Config файла**:
   - Создан `Config.xcconfig.example` как шаблон
   - Создан `Config.xcconfig` с реальным ключом (в .gitignore)
   - Добавлен `Config.swift` в модуль Core для доступа к ключу

3. **Обновление Info.plist**:
   - Добавлен ключ `UNSPLASH_ACCESS_KEY` со значением `$(UNSPLASH_ACCESS_KEY)`
   - Подключён `Config.xcconfig` к проекту через baseConfigurationReference

4. **Обновление README**:
   - Добавлены инструкции по настройке Unsplash API

**Результат**: Конфигурация Unsplash API настроена и защищена.

---

### Шаг 2.4: Создание модуля NetworkLayer

**Что делаем**: Создаем модуль для работы с сетью на базе URLSession.

**Подробные действия**:

1. **Создание пакета NetworkLayer**:
   - File → New → Package → Library
   - Название: `NetworkLayer`
   - Сохранён в `Packages/`

2. **Настройка зависимостей в Package.swift**:
   - Добавлены зависимости от `Models` и `Core`
   - Платформа: iOS 15+

3. **Создание протокола NetworkService**:
   - `NetworkService.swift` - протокол с методом `request<T: Decodable>(_ endpoint: Endpoint)`
   - `NetworkError` - enum с типами ошибок (invalidURL, noData, decodingError, serverError, unknown)

4. **Создание Endpoint**:
   - `Endpoint.swift` - структура для построения URL запросов
   - Автоматическое формирование URL для `api.unsplash.com`

5. **Реализация URLSessionNetworkService**:
   - `URLSessionNetworkService.swift` - реализация NetworkService
   - Автоматическая подстановка Authorization заголовка (Client-ID)
   - JSON декодирование с `.convertFromSnakeCase` стратегией
   - Обработка HTTP статус кодов

6. **Подключение NetworkLayer к проекту**:
   - Модуль добавлен в Frameworks
   - Подключён к target GalleryApp

**Результат**: Базовый сетевой слой создан и готов к использованию.

---

### Шаг 2.5: Создание UnsplashService

**Что делаем**: Создаем специализированный сервис для работы с Unsplash API.

**Подробные действия**:

1. **Создание протокола UnsplashServiceProtocol**:
   - `UnsplashService.swift` - протокол с методом `fetchPhotos(page:perPage:)`
   - Реализация `UnsplashService`, использующая `NetworkService`
   - Построение `Endpoint` с query параметрами для пагинации

2. **Создание Mock для тестов**:
   - `MockNetworkService.swift` - mock-объект для изоляции тестов
   - Поддержка симуляции ошибок через `shouldThrowError`
   - Возврат заранее подготовленных данных через `mockData`

3. **Написание Unit-теста**:
   - `UnsplashServiceTests.swift` - тесты для UnsplashService
   - Тест успешного сценария `testFetchPhotos_Success`
   - Использование паттерна Given-When-Then

4. **Обновление зависимостей**:
   - Models добавлен в testTarget для использования в тестах

**Результат**: Сетевой слой полностью готов к использованию с полным покрытием тестами.

---

## Архитектура проекта

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

## Тестирование

### Unit-тесты и Mock-объекты

**Как это работает**:
- **Mock** - это объект-заглушка (`MockNetworkService`), который имитирует реальный `NetworkService`
- **Unit-тесты** - проверяют код (`UnsplashService`), который работает с mock-объектом
- Тесты изолированы от реальных сетевых запросов - быстро и надёжно

**Пример использования**:
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

## Статус проекта

- ✅ Все модули компилируются без ошибок
- ✅ SwiftLint проходит без нарушений
- ✅ Unit-тесты написаны и проходят
- ✅ Конфигурация API ключа работает корректно
- ✅ Модули подключены к основному проекту
- ✅ Тесты запускаются на симуляторе

## Следующие шаги

- [ ] Создание DataLayer модуля
- [ ] Создание GalleryFeature модуля
- [ ] Создание DetailFeature модуля
- [ ] Интеграция всех модулей в единое приложение
