# iOS Gallery App

Приложение-галерея для просмотра изображений из Unsplash API с возможностью сохранения избранного.

## Контакты

- **Имя**: Дэннис Браун
- **Email**: brown_denny@icloud.com
- **GitHub**: https://github.com/Flapes32/GalleryApp

## О проекте

Тестовое задание для позиции iOS разработчика. Приложение демонстрирует:

- Работу с Unsplash API
- MVVM + Clean Architecture
- Модульную структуру на Swift Package Manager
- Локальное сохранение данных
- UIKit и программное создание UI

## Основные функции

- Просмотр фотографий из Unsplash в виде сетки
- Бесконечная пагинация (30 фото на запрос)
- Добавление фото в избранное
- Детальный просмотр с zoom
- Swipe-жесты для навигации между фото
- Кэширование изображений
- Pull-to-refresh

## Архитектура

### Паттерн: MVVM + Clean Architecture + Coordinator

### Модули (Swift Package Manager):

- **Core** — базовые утилиты и расширения
- **Models** — модели данных
- **NetworkLayer** — сетевой слой (URLSession)
- **DataLayer** — локальное хранилище (UserDefaults)
- **GalleryFeature** — экран галереи
- **DetailFeature** — экран деталей

### Используемые технологии:

- Swift 5.9+
- UIKit
- URLSession (async/await)
- Combine
- Swift Package Manager
- Kingfisher (кэширование изображений)
- SwiftLint (code quality)

### SOLID принципы:

См. файл [ARCHITECTURE.md](ARCHITECTURE.md)

## Установка и запуск

### Требования:

- Xcode 15.0+
- iOS 15.0+
- Swift 5.9+

### Инструкция:

1. Клонируйте репозиторий:

   ```
   git clone git@github.com:Flapes32/GalleryApp.git
   cd GalleryApp
   ```

2. Получите Unsplash API ключ:

   - Зарегистрируйтесь на https://unsplash.com/developers
   - Создайте приложение
   - Скопируйте Access Key

3. Настройте Config файл:

   ```
   cp Resources/Config.xcconfig.example Resources/Config.xcconfig
   ```

   Откройте `Resources/Config.xcconfig` и вставьте ваш API ключ:

   ```
   UNSPLASH_ACCESS_KEY = your_access_key_here
   ```

4. Откройте проект в Xcode:

   ```
   open GalleryApp.xcodeproj
   ```

5. Запустите проект (⌘R)

## Скриншоты

[Здесь будут скриншоты]

## Демо

[Ссылка на видео]

## Тестирование

Запуск тестов:

```
xcodebuild test -scheme GalleryApp -destination 'platform=iOS Simulator,name=iPhone 15'
```

Или в Xcode: Product → Test (⌘U)

## Git Workflow

Проект использует Git Flow:

- `main` — стабильная версия
- `develop` — основная ветка разработки
- `feature/*` — ветки для отдельных задач

### Conventional Commits:

- `[ADDED]` — новая функциональность
- `[FIXED]` — исправление бага
- `[REFACTORED]` — рефакторинг кода
- `[UPDATED]` — обновление существующей функции
- `[DOCS]` — обновление документации

## Дополнительные фичи

- Pull-to-refresh для обновления списка
- Empty state при отсутствии фотографий
- Zoom для детального просмотра
- Индикаторы загрузки
- Обработка ошибок сети

## Лицензия

MIT License

## Благодарности

- [Unsplash](https://unsplash.com) за бесплатный API
- [Kingfisher](https://github.com/onevcat/Kingfisher) за кэширование изображений
