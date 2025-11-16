# Архитектурные решения и SOLID принципы

## 📐 Общая архитектура

Проект использует **модульную архитектуру** с разделением на слои:
- **Models** - модели данных
- **Core** - базовые утилиты и расширения
- **NetworkLayer** - сетевой слой
- **DataLayer** - слой данных (persistence)
- **GalleryFeature** - фича галереи (MVVM-C)
- **DetailFeature** - фича детального просмотра

## 🎯 SOLID принципы

### 1. Single Responsibility Principle (SRP)

Каждый класс имеет одну причину для изменения:

#### View Layer
- **`GalleryViewController`** - отвечает только за отображение UI и взаимодействие с пользователем
- **`DetailViewController`** - отвечает только за отображение детальной информации об изображении
- **`GalleryCell`** - отвечает только за отображение одной ячейки в коллекции

#### ViewModel Layer
- **`GalleryViewModel`** - управляет бизнес-логикой галереи (загрузка фото, пагинация, избранное)
- **`DetailViewModel`** - управляет бизнес-логикой детального экрана (навигация между фото, избранное)

#### Service Layer
- **`UnsplashService`** - отвечает только за работу с Unsplash API
- **`URLSessionNetworkService`** - отвечает только за выполнение HTTP запросов
- **`FavoritesUseCase`** - управляет бизнес-логикой избранного (toggle, проверка статуса)

#### Repository Layer
- **`UserDefaultsFavoritesRepository`** - отвечает только за сохранение/загрузку избранного в UserDefaults
- **`FavoritesRepository`** (протокол) - определяет контракт для работы с избранным

#### Coordinator Layer
- **`GalleryCoordinator`** - отвечает только за навигацию между экранами

### 2. Open/Closed Principle (OCP)

Код открыт для расширения, закрыт для модификации:

#### Примеры расширяемости:

**NetworkService:**
```swift
// Можно добавить новую реализацию без изменения существующего кода
public protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

// Существующие реализации:
// - URLSessionNetworkService (production)
// - MockNetworkService (testing)
// - AlamofireNetworkService (можно добавить в будущем)
```

**FavoritesRepository:**
```swift
// Можно легко заменить UserDefaults на CoreData без изменения UseCase
public protocol FavoritesRepository {
    func addToFavorites(photoId: String) async throws
    func removeFromFavorites(photoId: String) async throws
    func isFavorite(photoId: String) async -> Bool
    func getAllFavorites() async -> Set<String>
}

// Существующие реализации:
// - UserDefaultsFavoritesRepository (текущая)
// - CoreDataFavoritesRepository (можно добавить)
// - RealmFavoritesRepository (можно добавить)
```

### 3. Liskov Substitution Principle (LSP)

Все реализации протоколов взаимозаменяемы:

#### NetworkService
- `URLSessionNetworkService` и `MockNetworkService` могут использоваться взаимозаменяемо
- В тестах `MockNetworkService` полностью заменяет `URLSessionNetworkService`
- `GalleryViewModel` работает одинаково с любой реализацией `NetworkService`

#### FavoritesRepository
- `UserDefaultsFavoritesRepository` может быть заменен на любую другую реализацию
- `FavoritesUseCase` работает одинаково с любой реализацией `FavoritesRepository`

#### UnsplashServiceProtocol
- `UnsplashService` может быть заменен на mock для тестирования
- `GalleryViewModel` не знает о конкретной реализации

### 4. Interface Segregation Principle (ISP)

Протоколы разделены по функциональности, клиенты не зависят от методов, которые не используют:

#### Разделение протоколов:

**NetworkService** - только для сетевых запросов:
```swift
public protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}
```

**UnsplashServiceProtocol** - только для работы с Unsplash API:
```swift
public protocol UnsplashServiceProtocol {
    func fetchPhotos(page: Int, perPage: Int) async throws -> [UnsplashPhoto]
}
```

**FavoritesRepository** - только для работы с хранилищем:
```swift
public protocol FavoritesRepository {
    func addToFavorites(photoId: String) async throws
    func removeFromFavorites(photoId: String) async throws
    func isFavorite(photoId: String) async -> Bool
    func getAllFavorites() async -> Set<String>
}
```

**FavoritesUseCaseProtocol** - только для бизнес-логики избранного:
```swift
public protocol FavoritesUseCaseProtocol {
    func toggleFavorite(photoId: String) async throws
    func isFavorite(photoId: String) async -> Bool
    func getFavorites() async -> Set<String>
}
```

**GalleryCoordinatorProtocol** - только для навигации:
```swift
public protocol GalleryCoordinatorProtocol: AnyObject {
    func showImageDetail(photo: UnsplashPhoto, allPhotos: [UnsplashPhoto])
}
```

### 5. Dependency Inversion Principle (DIP)

Модули высокого уровня не зависят от модулей низкого уровня. Оба зависят от абстракций:

#### Dependency Injection через протоколы:

**GalleryViewModel** зависит от протоколов, а не от конкретных реализаций:
```swift
public init(
    unsplashService: UnsplashServiceProtocol,  // протокол, не класс
    favoritesUseCase: FavoritesUseCaseProtocol,  // протокол, не класс
    coordinator: GalleryCoordinatorProtocol?  // протокол, не класс
)
```

**UnsplashService** зависит от протокола `NetworkService`:
```swift
public init(networkService: NetworkService)  // протокол, не URLSessionNetworkService
```

**FavoritesUseCase** зависит от протокола `FavoritesRepository`:
```swift
public init(repository: FavoritesRepository)  // протокол, не UserDefaultsFavoritesRepository
```

#### Dependency Injection в SceneDelegate:

```swift
// Создание зависимостей
let networkService = URLSessionNetworkService(accessKey: Config.unsplashAccessKey)
let unsplashService = UnsplashService(networkService: networkService)
let favoritesRepository = UserDefaultsFavoritesRepository()
let favoritesUseCase = FavoritesUseCase(repository: favoritesRepository)

// Инъекция через инициализатор
appCoordinator = GalleryCoordinator(
    navigationController: navigationController,
    unsplashService: unsplashService,  // протокол
    favoritesUseCase: favoritesUseCase  // протокол
)
```

## 🏗️ Архитектурные паттерны

### MVVM-C (Model-View-ViewModel-Coordinator)

#### Model
- `UnsplashPhoto`, `PhotoURLs`, `User` - модели данных из API

#### View
- `GalleryViewController`, `DetailViewController` - UI компоненты
- Отвечают только за отображение и пользовательский ввод

#### ViewModel
- `GalleryViewModel`, `DetailViewModel` - бизнес-логика
- Используют `@Published` для реактивного обновления UI
- Не зависят от UIKit

#### Coordinator
- `GalleryCoordinator` - управление навигацией
- Изолирует навигационную логику от View и ViewModel

### Repository Pattern

Разделение логики доступа к данным:
- **Repository** (`FavoritesRepository`) - абстракция для работы с данными
- **UseCase** (`FavoritesUseCase`) - бизнес-логика поверх Repository
- **Implementation** (`UserDefaultsFavoritesRepository`) - конкретная реализация

### Service Layer Pattern

Разделение сетевой логики:
- **NetworkService** - абстракция для HTTP запросов
- **UnsplashService** - специфичная логика для Unsplash API
- Легко тестируется через mock объекты

## 📦 Модульность

Проект разделен на независимые Swift Package Manager модули:

1. **Models** - чистые модели данных, без зависимостей
2. **Core** - базовые утилиты, расширения, конфигурация
3. **NetworkLayer** - сетевой слой, зависит от Models и Core
4. **DataLayer** - слой данных, зависит от Models
5. **GalleryFeature** - фича галереи, зависит от всех вышеперечисленных
6. **DetailFeature** - фича деталей, зависит от Models, Core, DataLayer

Каждый модуль может быть:
- Протестирован независимо
- Заменен на другую реализацию
- Переиспользован в других проектах

## 🧪 Тестируемость

Благодаря SOLID принципам, код легко тестируется:

- **Mock объекты** заменяют реальные реализации
- **Протоколы** позволяют создавать тестовые двойники
- **Dependency Injection** упрощает подмену зависимостей в тестах

Пример из `GalleryViewModelTests`:
```swift
var mockUnsplashService: MockUnsplashService!
var mockFavoritesUseCase: MockFavoritesUseCase!

sut = GalleryViewModel(
    unsplashService: mockUnsplashService,  // mock вместо реального сервиса
    favoritesUseCase: mockFavoritesUseCase,  // mock вместо реального use case
    coordinator: nil
)
```

## 🔄 Расширяемость

Архитектура позволяет легко добавлять новые функции:

1. **Новый источник данных** - реализовать новый `FavoritesRepository`
2. **Новая фича** - создать новый модуль по аналогии с `GalleryFeature`
3. **Новый API** - создать новый сервис, реализующий `NetworkService`
4. **Новая навигация** - расширить `GalleryCoordinatorProtocol`

## 📝 Заключение

Архитектура проекта следует SOLID принципам, что обеспечивает:
- ✅ Легкость тестирования
- ✅ Простоту поддержки
- ✅ Возможность расширения
- ✅ Переиспользование кода
- ✅ Независимость модулей

