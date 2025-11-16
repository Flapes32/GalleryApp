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

### Требования:

- Xcode 15.0+
- iOS 15.0+
- Swift 5.9+


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

