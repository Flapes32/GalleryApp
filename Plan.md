# Детальный План Разработки iOS Gallery App

## Обзор проекта

Этот документ содержит максимально подробный пошаговый план разработки iOS приложения-галереи для начинающего разработчика. Приложение будет построено с использованием модульной архитектуры на базе Swift Package Manager, архитектурного паттерна MVVM + Clean Architecture, и интеграции с Unsplash API[1].

Основная цель — создать приложение с двумя экранами (галерея и детали изображения), поддержкой пагинации, локального сохранения избранного и кэширования изображений[1]. Проект будет организован по принципам SOLID, с четкой структурой Git-истории и использованием SwiftLint для контроля качества кода[1].

## Фаза 0: Подготовка проекта и Git

### Шаг 0.1: Создание Git-репозитория и настройка SSH

**Что делаем**: Создаем публичный репозиторий на GitHub или GitLab и настраиваем безопасное подключение через SSH-ключи.

**Подробные действия**:

1. **Создание SSH-ключа** (если у вас его еще нет)[2][3]:
   - Откройте терминал на вашем компьютере
   - Введите команду: `ssh-keygen -t ed25519 -C "your_email@example.com"` (замените email на ваш)
   - Нажмите Enter для сохранения ключа в стандартное место
   - Можете установить пароль или оставить пустым (нажать Enter)
   - Ключ будет создан в папке `~/.ssh/`

2. **Добавление SSH-ключа в GitHub/GitLab**[2][3]:
   - Скопируйте публичный ключ командой: `cat ~/.ssh/id_ed25519.pub`
   - Зайдите на GitHub.com (или GitLab.com) → Settings → SSH and GPG keys
   - Нажмите "New SSH Key"
   - Вставьте скопированный ключ и сохраните

3. **Создание репозитория**[3]:
   - На GitHub: нажмите "New repository"
   - Название: например, `ios-gallery-app`
   - Сделайте репозиторий Public
   - НЕ добавляйте README, .gitignore или лицензию (сделаем позже)
   - Нажмите "Create repository"

4. **Клонирование репозитория на локальный компьютер**[2][3]:
   - Скопируйте SSH-адрес репозитория (кнопка "Code" → SSH)
   - В терминале перейдите в папку, где хотите хранить проект: `cd ~/Documents/Projects`
   - Клонируйте: `git clone git@github.com:your-username/ios-gallery-app.git`
   - Перейдите в папку проекта: `cd ios-gallery-app`

**Где искать информацию**: Официальная документация GitHub по SSH: https://docs.github.com/en/authentication/connecting-to-github-with-ssh[2][3]

**Результат**: У вас есть пустой Git-репозиторий, подключенный через SSH, склонированный на локальный компьютер.

***

### Шаг 0.2: Настройка Git Flow - создание веток main и develop

**Что делаем**: Создаем базовую структуру веток по методологии Git Flow[3][4][5].

**Подробные действия**:

1. **Создание начального коммита в main**[3][4]:
   - Создайте пустой файл README: `touch README.md`
   - Откройте README.md в любом текстовом редакторе и добавьте: `# iOS Gallery App`
   - Добавьте файл в Git: `git add README.md`
   - Сделайте первый коммит: `git commit -m "[ADDED] Initial README file"`
   - Отправьте на сервер: `git push origin main` (или `git push origin master`, в зависимости от названия ветки)

2. **Создание ветки develop**[3][4][5]:
   - Создайте и переключитесь на ветку develop: `git checkout -b develop`
   - Отправьте ветку на сервер: `git push origin develop`
   - В настройках GitHub/GitLab установите develop как ветку по умолчанию для pull requests

3. **Понимание Git Flow**[3][4][5]:
   - **main/master** — продакшн-версия, всегда стабильна
   - **develop** — основная ветка разработки, от нее создаются все feature-ветки
   - **feature/** — ветки для отдельных задач, создаются от develop
   - **Пример**: `feature/0.2-project-planning`, `feature/1.1-project-creation`

**Где искать информацию**: 
- Atlassian Git Flow tutorial: https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow[4]
- Conventional Commits: https://www.conventionalcommits.org/[1]

**Результат**: Репозиторий с двумя ветками — main (стабильная) и develop (для разработки).

***

### Шаг 0.3: Добавление .gitignore для iOS

**Что делаем**: Создаем файл .gitignore, чтобы не коммитить лишние файлы Xcode[1].

**Подробные действия**:

1. **Создание .gitignore**:
   - Убедитесь, что вы на ветке develop: `git branch` (должна быть зеленая звездочка у develop)
   - Создайте файл: `touch .gitignore`
   - Скопируйте содержимое из шаблона для iOS: https://github.com/github/gitignore/blob/main/Swift.gitignore
   - Откройте .gitignore в текстовом редакторе и вставьте содержимое

2. **Основные строки в .gitignore** (добавьте, если их нет)[1]:
   ```
   # Xcode
   *.xcodeproj/xcuserdata/
   *.xcworkspace/xcuserdata/
   
   # Swift Package Manager
   .build/
   
   # CocoaPods (если будете использовать)
   Pods/
   
   # Build products
   DerivedData/
   
   # Config files (для API ключей)
   Config.xcconfig
   Config.plist
   ```

3. **Коммит .gitignore**:
   - `git add .gitignore`
   - `git commit -m "[ADDED] iOS .gitignore file"`
   - `git push origin develop`

**Результат**: Проект настроен так, что временные файлы Xcode и чувствительные данные не попадут в Git.

***

### Шаг 0.4: Создание Feature-ветки для декомпозиции

**Что делаем**: Создаем первую feature-ветку для добавления документа с декомпозицией задачи[3].

**Подробные действия**:

1. **Переключение на develop**:
   - `git checkout develop`
   - `git pull origin develop` (обновляем локальную версию)

2. **Создание feature-ветки**[3]:
   - `git checkout -b feature/0.2-project-planning`

3. **Добавление декомпозиции**:
   - Создайте файл: `touch PROJECT_PLAN.md`
   - Откройте файл и добавьте содержимое из вашего List.md (или напишите краткую декомпозицию)[6]
   - Пример структуры:
     ```markdown
     # Декомпозиция проекта iOS Gallery App
     
     ## Архитектура
     - MVVM + Clean Architecture
     - Модульная структура на Swift Package Manager
     
     ## Модули
     1. Core (общие утилиты)
     2. NetworkLayer (работа с API)
     3. DataLayer (локальное хранилище)
     4. GalleryFeature (экран галереи)
     5. DetailFeature (экран деталей)
     
     ## Фазы разработки
     [описание фаз]
     ```

4. **Коммит и merge в develop**[1][3]:
   - `git add PROJECT_PLAN.md`
   - `git commit -m "[ADDED] Project decomposition and architecture planning"`
   - `git push origin feature/0.2-project-planning`
   - Переключитесь на develop: `git checkout develop`
   - Смержите фичу: `git merge feature/0.2-project-planning`
   - Отправьте изменения: `git push origin develop`
   - Удалите локальную feature-ветку (опционально): `git branch -d feature/0.2-project-planning`

**Где искать информацию**: Git branching best practices[3][4]

**Результат**: Первая фича завершена, в develop есть файл с планом проекта.

***

## Фаза 1: Создание проекта и настройка окружения

### Шаг 1.1: Создание Xcode-проекта

**Что делаем**: Создаем новый iOS-проект в Xcode с правильными настройками[1][7].

**Подробные действия**:

1. **Создание feature-ветки**:
   - `git checkout develop`
   - `git checkout -b feature/1.1-project-creation`

2. **Создание проекта в Xcode**[1]:
   - Откройте Xcode
   - File → New → Project
   - Выберите iOS → App
   - Заполните поля:
     - Product Name: `GalleryApp`
     - Team: оставьте "None" или выберите свой
     - Organization Identifier: `com.yourname` (например, `com.johndoe`)
     - Interface: **Storyboard** (используем UIKit)[1]
     - Language: **Swift**[1]
     - Storage: снимите галочку с Core Data (настроим позже)
     - Unit Tests и UI Tests: оставьте отмеченными
   - В поле "Save As" выберите папку вашего Git-репозитория
   - Снимите галочку "Create Git repository on my Mac" (репозиторий уже есть)

3. **Настройка Deployment Target**[1]:
   - В Xcode выберите проект (синяя иконка в навигаторе слева)
   - Targets → GalleryApp → General
   - Minimum Deployments: установите **iOS 15.0**[1]

4. **Первый коммит проекта**[1]:
   - `git add .`
   - `git commit -m "[ADDED] Initial Xcode project setup with UIKit and iOS 15 target"`
   - `git push origin feature/1.1-project-creation`

**Результат**: Базовый Xcode-проект создан и закоммичен.

***

### Шаг 1.2: Организация структуры папок в проекте

**Что делаем**: Создаем логичную структуру папок для модульного проекта[8][9][10][11].

**Подробные действия**:

1. **Создание базовых папок в Finder** (не в Xcode!)[8][10]:
   - Откройте Finder и найдите папку проекта
   - Внутри папки `GalleryApp` создайте следующую структуру[8][11]:
     ```
     GalleryApp/
     ├── App/
     │   ├── AppDelegate.swift
     │   └── SceneDelegate.swift
     ├── Resources/
     │   ├── Assets.xcassets
     │   └── Info.plist
     ├── Packages/
     │   (здесь будут модули SPM)
     └── SupportingFiles/
         └── LaunchScreen.storyboard
     ```

2. **Перемещение файлов**[10]:
   - Переместите `AppDelegate.swift` и `SceneDelegate.swift` в папку `App/`
   - Переместите `Assets.xcassets`, `Info.plist` в папку `Resources/`
   - Переместите `LaunchScreen.storyboard` в `SupportingFiles/`
   - Удалите старый `Main.storyboard` (мы будем создавать UI программно)

3. **Обновление структуры в Xcode**[10]:
   - В Xcode удалите старые файлы (правый клик → Delete → Remove Reference)
   - Перетащите папки из Finder в Xcode
   - При добавлении выберите "Create groups" и "Copy items if needed"

4. **Обновление Info.plist**:
   - В `Info.plist` найдите `UIApplicationSceneManifest` → `UISceneConfigurations` → `UIWindowSceneSessionRoleApplication`
   - Удалите строку `UISceneStoryboardFile` (Main storyboard file base name)
   - Это позволит создавать UI программно

5. **Коммит изменений**[1]:
   - `git add .`
   - `git commit -m "[REFACTORED] Organized project folder structure"`
   - `git push origin feature/1.1-project-creation`

**Где искать информацию**: Best practices for Xcode project structure[8][9][10][11]

**Результат**: Проект имеет организованную структуру папок, готов к модульной разработке.

***

### Шаг 1.3: Настройка SwiftLint

**Что делаем**: Интегрируем SwiftLint для автоматической проверки качества кода[1][12][13].

**Подробные действия**:

1. **Установка SwiftLint через Homebrew**[12][13]:
   - Откройте терминал
   - Если у вас нет Homebrew, установите: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
   - Установите SwiftLint: `brew install swiftlint`
   - Проверьте установку: `swiftlint version`

2. **Создание .swiftlint.yml**[12][13]:
   - В корне проекта (рядом с .gitignore) создайте файл: `touch .swiftlint.yml`
   - Откройте файл и добавьте базовые правила:
     ```yaml
     disabled_rules:
       - trailing_whitespace
     
     opt_in_rules:
       - force_unwrapping
     
     excluded:
       - Pods
       - .build
       - DerivedData
     
     line_length:
       warning: 120
       error: 150
     
     identifier_name:
       min_length:
         warning: 2
       max_length:
         warning: 50
     ```

3. **Добавление Run Script в Xcode**[12][13]:
   - В Xcode выберите проект → Targets → GalleryApp → Build Phases
   - Нажмите "+" → "New Run Script Phase"
   - Переименуйте в "SwiftLint"
   - Добавьте скрипт:
     ```bash
     if which swiftlint >/dev/null; then
       swiftlint
     else
       echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
     fi
     ```
   - Перетащите эту фазу выше "Compile Sources"

4. **Тест SwiftLint**:
   - Нажмите Cmd+B (Build)
   - В Issue Navigator (⌘+5) увидите предупреждения от SwiftLint (если есть нарушения)

5. **Коммит настроек**[1]:
   - `git add .swiftlint.yml`
   - `git commit -m "[ADDED] SwiftLint configuration and build phase"`
   - `git push origin feature/1.1-project-creation`

**Где искать информацию**: SwiftLint GitHub repo и документация[12][13]

**Результат**: SwiftLint настроен и работает при каждой сборке проекта.

***

### Шаг 1.4: Настройка Pre-commit Hook для SwiftLint

**Что делаем**: Добавляем Git-хук, который проверяет код перед каждым коммитом[12][14][13][15].

**Подробные действия**:

1. **Создание pre-commit hook**[12][13]:
   - В терминале перейдите в папку проекта: `cd путь/к/ios-gallery-app`
   - Создайте файл хука: `touch .git/hooks/pre-commit`
   - Сделайте его исполняемым: `chmod +x .git/hooks/pre-commit`

2. **Добавление скрипта в pre-commit**[12][14][13]:
   - Откройте файл `.git/hooks/pre-commit` в текстовом редакторе
   - Добавьте следующий код:
     ```bash
     #!/bin/bash
     
     # SwiftLint pre-commit hook
     
     SWIFT_LINT=$(which swiftlint)
     
     if [[ -e "${SWIFT_LINT}" ]]; then
         echo "SwiftLint Start..."
         
         # Получаем список staged файлов .swift
         git diff --cached --name-only --diff-filter=d | grep ".swift$" | while read filename; do
             ${SWIFT_LINT} lint --path "${filename}"
         done
         
         RESULT=$?
         
         if [ $RESULT -eq 0 ]; then
             echo "✅ SwiftLint Passed"
         else
             echo "❌ SwiftLint Failed. Fix violations before commit."
             exit 1
         fi
     else
         echo "⚠️  SwiftLint not installed"
         exit 1
     fi
     ```

3. **Тест pre-commit hook**[12][13]:
   - Создайте тестовый файл с нарушением
   - Попробуйте закоммитить: `git commit -m "test"`
   - Хук должен остановить коммит, если есть ошибки

4. **Документирование**:
   - Добавьте информацию о хуке в README.md:
     ```markdown
     ## Development Setup
     
     Pre-commit hook автоматически установлен в .git/hooks/
     Он проверяет код SwiftLint перед каждым коммитом.
     ```

5. **Завершение feature-ветки**[3]:
   - `git checkout develop`
   - `git merge feature/1.1-project-creation`
   - `git push origin develop`
   - `git branch -d feature/1.1-project-creation`

**Где искать информацию**: Git hooks documentation[12][14][13][15]

**Результат**: Перед каждым коммитом автоматически проверяется качество кода.

***

### Шаг 1.5: Выбор и добавление менеджера зависимостей (SPM)

**Что делаем**: Настраиваем Swift Package Manager для управления модулями и внешними библиотеками[2][16][17].

**Подробные действия**:

1. **Понимание SPM**[2][16][17]:
   - SPM — встроенный в Xcode инструмент для управления пакетами
   - Не требует установки (в отличие от CocoaPods)
   - Используется для создания модулей и подключения библиотек

2. **Создание папки для локальных пакетов**[2][16][17]:
   - В корне проекта создайте папку `Packages/`: `mkdir Packages`
   - Здесь будут храниться все модули приложения

3. **Планирование модулей**[2][16][17][18]:
   - **Core** — базовые утилиты, расширения
   - **NetworkLayer** — работа с сетью и Unsplash API
   - **DataLayer** — локальное хранилище и Core Data
   - **GalleryFeature** — UI и логика экрана галереи
   - **DetailFeature** — UI и логика экрана деталей
   - **Models** — общие модели данных

4. **Документирование архитектуры**:
   - Обновите PROJECT_PLAN.md с диаграммой зависимостей:
     ```
     App → GalleryFeature → NetworkLayer → Core
       ↓                  → DataLayer    → Models
       → DetailFeature   → NetworkLayer
                        → DataLayer
     ```

5. **Коммит структуры**:
   - `git checkout -b feature/1.2-modular-structure`
   - `git add Packages/`
   - `git commit -m "[ADDED] Packages folder for SPM modules"`
   - `git push origin feature/1.2-modular-structure`

**Где искать информацию**: Apple Swift Package Manager docs[2][16][17]

**Результат**: Проект готов к созданию модулей через SPM.

***

## Фаза 2: Создание модулей и сетевого слоя

### Шаг 2.1: Создание модуля Core

**Что делаем**: Создаем первый Swift Package для базовых утилит и расширений[2][16][17].

**Подробные действия**:

1. **Создание пакета через Xcode**[2][16][17]:
   - File → New → Package
   - Шаблон: Library
   - Название: `Core`
   - Место сохранения: выберите папку `Packages/`
   - Нажмите Create

2. **Настройка Package.swift**[2][16][17]:
   - Откройте `Packages/Core/Package.swift`
   - Настройте платформу и targets:
     ```swift
     // swift-tools-version: 5.9
     import PackageDescription
     
     let package = Package(
         name: "Core",
         platforms: [
             .iOS(.v15)
         ],
         products: [
             .library(
                 name: "Core",
                 targets: ["Core"]),
         ],
         dependencies: [],
         targets: [
             .target(
                 name: "Core",
                 dependencies: []),
             .testTarget(
                 name: "CoreTests",
                 dependencies: ["Core"]),
         ]
     )
     ```

3. **Создание базовых расширений**[7][19]:
   - Удалите файл `Core.swift` из `Sources/Core/`
   - Создайте файл `UIView+Extensions.swift`:
     ```swift
     import UIKit
     
     public extension UIView {
         func addSubviews(_ views: UIView...) {
             views.forEach { addSubview($0) }
         }
     }
     ```
   - Создайте файл `UIImageView+Extensions.swift`:
     ```swift
     import UIKit
     
     public extension UIImageView {
         func setImage(from url: URL, placeholder: UIImage? = nil) {
             self.image = placeholder
             // Временная реализация (позже используем Kingfisher)
         }
     }
     ```

4. **Подключение модуля к основному проекту**[2][16]:
   - В Xcode выберите проект → Targets → GalleryApp → General
   - Frameworks, Libraries, and Embedded Content → нажмите "+"
   - Добавьте "Add Other" → "Add Package Dependency"
   - Выберите локальный пакет `Packages/Core`
   - В появившемся окне выберите "Core" и нажмите "Add Package"

5. **Коммит модуля Core**[1]:
   - `git add Packages/Core`
   - `git commit -m "[ADDED] Core module with base utilities and extensions"`
   - `git push origin feature/1.2-modular-structure`

**Результат**: Модуль Core создан и подключен к проекту.

***

### Шаг 2.2: Создание модуля Models

**Что делаем**: Создаем модуль для общих моделей данных[7][20].

**Подробные действия**:

1. **Создание пакета Models**[2][16]:
   - File → New → Package
   - Название: `Models`
   - Сохранить в `Packages/`

2. **Создание модели UnsplashPhoto**[1][21]:
   - В `Sources/Models/` создайте файл `UnsplashPhoto.swift`:
     ```swift
     import Foundation
     
     public struct UnsplashPhoto: Codable, Identifiable {
         public let id: String
         public let createdAt: String?
         public let width: Int
         public let height: Int
         public let color: String?
         public let description: String?
         public let altDescription: String?
         public let urls: PhotoURLs
         public let user: User?
         
         enum CodingKeys: String, CodingKey {
             case id
             case createdAt = "created_at"
             case width, height, color, description
             case altDescription = "alt_description"
             case urls, user
         }
         
         public init(id: String, createdAt: String?, width: Int, height: Int, 
                    color: String?, description: String?, altDescription: String?, 
                    urls: PhotoURLs, user: User?) {
             self.id = id
             self.createdAt = createdAt
             self.width = width
             self.height = height
             self.color = color
             self.description = description
             self.altDescription = altDescription
             self.urls = urls
             self.user = user
         }
     }
     
     public struct PhotoURLs: Codable {
         public let raw: String
         public let full: String
         public let regular: String
         public let small: String
         public let thumb: String
         
         public init(raw: String, full: String, regular: String, small: String, thumb: String) {
             self.raw = raw
             self.full = full
             self.regular = regular
             self.small = small
             self.thumb = thumb
         }
     }
     
     public struct User: Codable {
         public let id: String
         public let username: String
         public let name: String
         
         public init(id: String, username: String, name: String) {
             self.id = id
             self.username = username
             self.name = name
         }
     }
     ```

3. **Подключение Models к проекту**:
   - Targets → GalleryApp → General → Frameworks
   - Добавьте локальный пакет Models

4. **Коммит**[1]:
   - `git add Packages/Models`
   - `git commit -m "[ADDED] Models module with UnsplashPhoto structure"`
   - `git push origin feature/1.2-modular-structure`

**Результат**: Модуль Models создан с моделями для Unsplash API.

***

### Шаг 2.3: Регистрация в Unsplash API

**Что делаем**: Получаем API ключ для доступа к Unsplash[1][22][23].

**Подробные действия**:

1. **Регистрация на Unsplash**[1][22]:
   - Перейдите на https://unsplash.com/developers
   - Нажмите "Register as a developer"
   - Войдите или зарегистрируйтесь
   - Заполните профиль разработчика

2. **Создание приложения**[1][22][23]:
   - На странице разработчика нажмите "New Application"
   - Примите условия использования API
   - Заполните информацию о приложении:
     - Application name: "iOS Gallery Test App"
     - Description: "Test task for iOS developer position"
   - Нажмите "Create application"

3. **Копирование Access Key**[1][22][23]:
   - На странице вашего приложения найдите "Access Key"
   - Скопируйте его (это ваш API ключ)
   - НЕ публикуйте его в Git!

4. **Создание Config файла**[1]:
   - В Xcode: File → New → File → Configuration Settings File
   - Название: `Config.xcconfig`
   - Сохраните в папке `Resources/`
   - Добавьте строку:
     ```
     UNSPLASH_ACCESS_KEY = ваш_access_key_здесь
     ```
   - Убедитесь, что `Config.xcconfig` есть в .gitignore

5. **Создание Config.swift для доступа к ключу**:
   - В модуле Core создайте `Config.swift`:
     ```swift
     import Foundation
     
     public enum Config {
         public static var unsplashAccessKey: String {
             guard let key = Bundle.main.object(forInfoDictionaryKey: "UNSPLASH_ACCESS_KEY") as? String else {
                 fatalError("UNSPLASH_ACCESS_KEY not found in Config")
             }
             return key
         }
     }
     ```

6. **Обновление Info.plist**:
   - Откройте `Info.plist` как Source Code (правый клик → Open As → Source Code)
   - Добавьте:
     ```xml
     <key>UNSPLASH_ACCESS_KEY</key>
     <string>$(UNSPLASH_ACCESS_KEY)</string>
     ```

7. **Создание Config.xcconfig.example**[1]:
   - Создайте файл `Config.xcconfig.example` (без реального ключа):
     ```
     UNSPLASH_ACCESS_KEY = your_access_key_here
     ```
   - Этот файл коммитим в Git как пример

8. **Обновление README**:
   - Добавьте инструкцию:
     ```markdown
     ## Configuration
     
     1. Зарегистрируйтесь на https://unsplash.com/developers
     2. Создайте приложение и получите Access Key
     3. Скопируйте Config.xcconfig.example в Config.xcconfig
     4. Замените your_access_key_here на ваш ключ
     ```

9. **Коммит**[1]:
   - `git add Config.xcconfig.example README.md`
   - `git commit -m "[ADDED] Unsplash API configuration setup"`
   - `git push origin feature/1.2-modular-structure`

**Где искать информацию**: Unsplash API Documentation[22][23]

**Результат**: API ключ получен и безопасно настроен в проекте.

***

### Шаг 2.4: Создание модуля NetworkLayer

**Что делаем**: Создаем модуль для работы с сетью на базе URLSession[1][7][20].

**Подробные действия**:

1. **Создание пакета NetworkLayer**[2][16]:
   - File → New → Package → Library
   - Название: `NetworkLayer`
   - Сохранить в `Packages/`

2. **Настройка зависимостей в Package.swift**[2][16]:
   ```swift
   // Packages/NetworkLayer/Package.swift
   let package = Package(
       name: "NetworkLayer",
       platforms: [.iOS(.v15)],
       products: [
           .library(name: "NetworkLayer", targets: ["NetworkLayer"]),
       ],
       dependencies: [
           .package(path: "../Models"),
           .package(path: "../Core")
       ],
       targets: [
           .target(
               name: "NetworkLayer",
               dependencies: ["Models", "Core"]),
           .testTarget(
               name: "NetworkLayerTests",
               dependencies: ["NetworkLayer"]),
       ]
   )
   ```

3. **Создание протокола NetworkService**[7][20]:
   - В `Sources/NetworkLayer/` создайте `NetworkService.swift`:
     ```swift
     import Foundation
     
     public protocol NetworkService {
         func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
     }
     
     public enum NetworkError: Error {
         case invalidURL
         case noData
         case decodingError
         case serverError(Int)
         case unknown
     }
     ```

4. **Создание Endpoint**[7][20]:
   - Создайте файл `Endpoint.swift`:
     ```swift
     import Foundation
     
     public struct Endpoint {
         let path: String
         let queryItems: [URLQueryItem]
         
         public init(path: String, queryItems: [URLQueryItem] = []) {
             self.path = path
             self.queryItems = queryItems
         }
         
         public var url: URL? {
             var components = URLComponents()
             components.scheme = "https"
             components.host = "api.unsplash.com"
             components.path = path
             components.queryItems = queryItems
             return components.url
         }
     }
     ```

5. **Реализация URLSessionNetworkService**[7][20]:
   - Создайте `URLSessionNetworkService.swift`:
     ```swift
     import Foundation
     import Core
     
     public final class URLSessionNetworkService: NetworkService {
         private let session: URLSession
         private let accessKey: String
         
         public init(session: URLSession = .shared, accessKey: String) {
             self.session = session
             self.accessKey = accessKey
         }
         
         public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
             guard let url = endpoint.url else {
                 throw NetworkError.invalidURL
             }
             
             var request = URLRequest(url: url)
             request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
             
             let (data, response) = try await session.data(for: request)
             
             guard let httpResponse = response as? HTTPURLResponse else {
                 throw NetworkError.unknown
             }
             
             guard (200...299).contains(httpResponse.statusCode) else {
                 throw NetworkError.serverError(httpResponse.statusCode)
             }
             
             do {
                 let decoder = JSONDecoder()
                 decoder.keyDecodingStrategy = .convertFromSnakeCase
                 return try decoder.decode(T.self, from: data)
             } catch {
                 throw NetworkError.decodingError
             }
         }
     }
     ```

6. **Подключение NetworkLayer к проекту**:
   - Targets → GalleryApp → General → Frameworks
   - Добавьте NetworkLayer

7. **Коммит**[1]:
   - `git add Packages/NetworkLayer`
   - `git commit -m "[ADDED] NetworkLayer module with URLSession implementation"`
   - `git push origin feature/1.2-modular-structure`

**Результат**: Базовый сетевой слой создан и готов к использованию.

***

### Шаг 2.5: Создание UnsplashService

**Что делаем**: Создаем специализированный сервис для работы с Unsplash API[1][7].

**Подробные действия**:

1. **Создание протокола UnsplashServiceProtocol**[7][20]:
   - В NetworkLayer создайте `UnsplashService.swift`:
     ```swift
     import Foundation
     import Models
     
     public protocol UnsplashServiceProtocol {
         func fetchPhotos(page: Int, perPage: Int) async throws -> [UnsplashPhoto]
     }
     
     public final class UnsplashService: UnsplashServiceProtocol {
         private let networkService: NetworkService
         
         public init(networkService: NetworkService) {
             self.networkService = networkService
         }
         
         public func fetchPhotos(page: Int = 1, perPage: Int = 30) async throws -> [UnsplashPhoto] {
             let endpoint = Endpoint(
                 path: "/photos",
                 queryItems: [
                     URLQueryItem(name: "page", value: "\(page)"),
                     URLQueryItem(name: "per_page", value: "\(perPage)")
                 ]
             )
             
             return try await networkService.request(endpoint)
         }
     }
     ```

2. **Создание Mock для тестов**[7]:
   - В `Tests/NetworkLayerTests/` создайте `MockNetworkService.swift`:
     ```swift
     import Foundation
     @testable import NetworkLayer
     import Models
     
     final class MockNetworkService: NetworkService {
         var mockData: Any?
         var shouldThrowError = false
         
         func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
             if shouldThrowError {
                 throw NetworkError.unknown
             }
             
             guard let data = mockData as? T else {
                 throw NetworkError.decodingError
             }
             
             return data
         }
     }
     ```

3. **Написание Unit-теста**[1][7]:
   - В `NetworkLayerTests.swift`:
     ```swift
     import XCTest
     @testable import NetworkLayer
     import Models
     
     final class UnsplashServiceTests: XCTestCase {
         var sut: UnsplashService!
         var mockNetworkService: MockNetworkService!
         
         override func setUp() {
             super.setUp()
             mockNetworkService = MockNetworkService()
             sut = UnsplashService(networkService: mockNetworkService)
         }
         
         func testFetchPhotos_Success() async throws {
             // Given
             let mockPhotos = [
                 UnsplashPhoto(
                     id: "1",
                     createdAt: nil,
                     width: 1000,
                     height: 1000,
                     color: "#000",
                     description: "Test",
                     altDescription: "Test Alt",
                     urls: PhotoURLs(raw: "", full: "", regular: "", small: "", thumb: ""),
                     user: nil
                 )
             ]
             mockNetworkService.mockData = mockPhotos
             
             // When
             let result = try await sut.fetchPhotos(page: 1, perPage: 30)
             
             // Then
             XCTAssertEqual(result.count, 1)
             XCTAssertEqual(result.first?.id, "1")
         }
     }
     ```

4. **Запуск тестов**:
   - В Xcode: Product → Test (или Cmd+U)
   - Убедитесь, что тесты проходят

5. **Коммит**[1]:
   - `git add .`
   - `git commit -m "[ADDED] UnsplashService with unit tests"`
   - `git push origin feature/1.2-modular-structure`

6. **Завершение feature-ветки**[3]:
   - `git checkout develop`
   - `git merge feature/1.2-modular-structure`
   - `git push origin develop`

**Результат**: Сетевой слой полностью готов к использованию.

***

## Фаза 3: Создание слоя данных

### Шаг 3.1: Создание модуля DataLayer

**Что делаем**: Создаем модуль для локального хранения избранных изображений[1][24][25].

**Подробные действия**:

1. **Создание новой feature-ветки**:
   - `git checkout develop`
   - `git checkout -b feature/3.1-data-layer`

2. **Создание пакета DataLayer**[2][16]:
   - File → New → Package → Library
   - Название: `DataLayer`
   - Сохранить в `Packages/`

3. **Настройка Package.swift**:
   ```swift
   let package = Package(
       name: "DataLayer",
       platforms: [.iOS(.v15)],
       products: [
           .library(name: "DataLayer", targets: ["DataLayer"]),
       ],
       dependencies: [
           .package(path: "../Models")
       ],
       targets: [
           .target(name: "DataLayer", dependencies: ["Models"]),
           .testTarget(name: "DataLayerTests", dependencies: ["DataLayer"]),
       ]
   )
   ```

4. **Создание протокола FavoritesRepository**[7][20][25]:
   - В `Sources/DataLayer/` создайте `FavoritesRepository.swift`:
     ```swift
     import Foundation
     
     public protocol FavoritesRepository {
         func addToFavorites(photoId: String) async throws
         func removeFromFavorites(photoId: String) async throws
         func isFavorite(photoId: String) async -> Bool
         func getAllFavorites() async -> Set<String>
     }
     ```

5. **Реализация UserDefaultsRepository**[24][25]:
   - Создайте `UserDefaultsFavoritesRepository.swift`:
     ```swift
     import Foundation
     
     public final class UserDefaultsFavoritesRepository: FavoritesRepository {
         private let userDefaults: UserDefaults
         private let favoritesKey = "favorites_photos"
         
         public init(userDefaults: UserDefaults = .standard) {
             self.userDefaults = userDefaults
         }
         
         public func addToFavorites(photoId: String) async throws {
             var favorites = await getAllFavorites()
             favorites.insert(photoId)
             userDefaults.set(Array(favorites), forKey: favoritesKey)
         }
         
         public func removeFromFavorites(photoId: String) async throws {
             var favorites = await getAllFavorites()
             favorites.remove(photoId)
             userDefaults.set(Array(favorites), forKey: favoritesKey)
         }
         
         public func isFavorite(photoId: String) async -> Bool {
             let favorites = await getAllFavorites()
             return favorites.contains(photoId)
         }
         
         public func getAllFavorites() async -> Set<String> {
             let array = userDefaults.stringArray(forKey: favoritesKey) ?? []
             return Set(array)
         }
     }
     ```

6. **Создание Use Case для избранного**[7][20]:
   - Создайте `FavoritesUseCase.swift`:
     ```swift
     import Foundation
     
     public protocol FavoritesUseCaseProtocol {
         func toggleFavorite(photoId: String) async throws
         func isFavorite(photoId: String) async -> Bool
         func getFavorites() async -> Set<String>
     }
     
     public final class FavoritesUseCase: FavoritesUseCaseProtocol {
         private let repository: FavoritesRepository
         
         public init(repository: FavoritesRepository) {
             self.repository = repository
         }
         
         public func toggleFavorite(photoId: String) async throws {
             let isFav = await repository.isFavorite(photoId: photoId)
             if isFav {
                 try await repository.removeFromFavorites(photoId: photoId)
             } else {
                 try await repository.addToFavorites(photoId: photoId)
             }
         }
         
         public func isFavorite(photoId: String) async -> Bool {
             return await repository.isFavorite(photoId: photoId)
         }
         
         public func getFavorites() async -> Set<String> {
             return await repository.getAllFavorites()
         }
     }
     ```

7. **Написание тестов**[7]:
   - В `DataLayerTests.swift`:
     ```swift
     import XCTest
     @testable import DataLayer
     
     final class FavoritesUseCaseTests: XCTestCase {
         var sut: FavoritesUseCase!
         var repository: UserDefaultsFavoritesRepository!
         
         override func setUp() {
             super.setUp()
             let testDefaults = UserDefaults(suiteName: "test")!
             testDefaults.removePersistentDomain(forName: "test")
             repository = UserDefaultsFavoritesRepository(userDefaults: testDefaults)
             sut = FavoritesUseCase(repository: repository)
         }
         
         func testToggleFavorite_AddsToFavorites() async throws {
             // When
             try await sut.toggleFavorite(photoId: "test-1")
             
             // Then
             let isFav = await sut.isFavorite(photoId: "test-1")
             XCTAssertTrue(isFav)
         }
         
         func testToggleFavorite_RemovesFromFavorites() async throws {
             // Given
             try await sut.toggleFavorite(photoId: "test-1")
             
             // When
             try await sut.toggleFavorite(photoId: "test-1")
             
             // Then
             let isFav = await sut.isFavorite(photoId: "test-1")
             XCTAssertFalse(isFav)
         }
     }
     ```

8. **Подключение к проекту**:
   - Targets → GalleryApp → Frameworks → добавьте DataLayer

9. **Коммит**[1]:
   - `git add Packages/DataLayer`
   - `git commit -m "[ADDED] DataLayer module with favorites persistence"`
   - `git push origin feature/3.1-data-layer`

**Результат**: Модуль для работы с избранным создан и протестирован.

***

### Шаг 3.2: Интеграция библиотеки кэширования изображений

**Что делаем**: Добавляем Kingfisher для кэширования изображений[1][26][27][28].

**Подробные действия**:

1. **Добавление Kingfisher через SPM**[26][27]:
   - File → Add Package Dependencies
   - В поле поиска введите: `https://github.com/onevcat/Kingfisher.git`
   - Выберите версию: "Up to Next Major Version" 7.0.0
   - Нажмите "Add Package"
   - Выберите цели: GalleryApp, Core
   - Нажмите "Add Package"

2. **Обновление UIImageView+Extensions**[27]:
   - Откройте `Packages/Core/Sources/Core/UIImageView+Extensions.swift`
   - Обновите:
     ```swift
     import UIKit
     import Kingfisher
     
     public extension UIImageView {
         func setImage(from urlString: String, placeholder: UIImage? = nil) {
             guard let url = URL(string: urlString) else { return }
             
             self.kf.indicatorType = .activity
             self.kf.setImage(
                 with: url,
                 placeholder: placeholder,
                 options: [
                     .transition(.fade(0.2)),
                     .cacheOriginalImage
                 ]
             )
         }
     }
     ```

3. **Настройка Kingfisher**[27]:
   - В Core создайте `ImageCacheConfiguration.swift`:
     ```swift
     import Foundation
     import Kingfisher
     
     public enum ImageCacheConfiguration {
         public static func configure() {
             let cache = ImageCache.default
             cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024 // 100 MB
             cache.diskStorage.config.sizeLimit = 200 * 1024 * 1024 // 200 MB
         }
     }
     ```

4. **Вызов конфигурации в AppDelegate**:
   - Откройте `App/AppDelegate.swift`
   - В `application(_:didFinishLaunchingWithOptions:)`:
     ```swift
     import Core
     
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         ImageCacheConfiguration.configure()
         return true
     }
     ```

5. **Коммит**[1]:
   - `git add .`
   - `git commit -m "[ADDED] Kingfisher for image caching with custom configuration"`
   - `git push origin feature/3.1-data-layer`

6. **Завершение feature**[3]:
   - `git checkout develop`
   - `git merge feature/3.1-data-layer`
   - `git push origin develop`

**Где искать информацию**: Kingfisher documentation[26][27][28]

**Результат**: Кэширование изображений настроено.

***

## Фаза 4: Создание экрана Gallery

### Шаг 4.1: Создание модуля GalleryFeature

**Что делаем**: Создаем модуль для экрана галереи с MVVM архитектурой[1][7][20].

**Подробные действия**:

1. **Создание feature-ветки**:
   - `git checkout develop`
   - `git checkout -b feature/4.1-gallery-screen`

2. **Создание пакета GalleryFeature**[2][16]:
   - File → New → Package → Library
   - Название: `GalleryFeature`
   - Сохранить в `Packages/`

3. **Настройка Package.swift**:
   ```swift
   let package = Package(
       name: "GalleryFeature",
       platforms: [.iOS(.v15)],
       products: [
           .library(name: "GalleryFeature", targets: ["GalleryFeature"]),
       ],
       dependencies: [
           .package(path: "../Models"),
           .package(path: "../Core"),
           .package(path: "../NetworkLayer"),
           .package(path: "../DataLayer")
       ],
       targets: [
           .target(
               name: "GalleryFeature",
               dependencies: ["Models", "Core", "NetworkLayer", "DataLayer"]),
           .testTarget(
               name: "GalleryFeatureTests",
               dependencies: ["GalleryFeature"]),
       ]
   )
   ```

4. **Создание структуры модуля**[7][8][11]:
   - В `Sources/GalleryFeature/` создайте папки:
     - `View/`
     - `ViewModel/`
     - `Coordinator/`

5. **Создание GalleryCoordinator**[29][30][31]:
   - В `Coordinator/` создайте `GalleryCoordinator.swift`:
     ```swift
     import UIKit
     import Models
     
     public protocol GalleryCoordinatorProtocol: AnyObject {
         func showImageDetail(photo: UnsplashPhoto, allPhotos: [UnsplashPhoto])
     }
     
     public final class GalleryCoordinator: GalleryCoordinatorProtocol {
         private weak var navigationController: UINavigationController?
         
         public init(navigationController: UINavigationController?) {
             self.navigationController = navigationController
         }
         
         public func start() {
             let viewModel = GalleryViewModel(coordinator: self)
             let viewController = GalleryViewController(viewModel: viewModel)
             navigationController?.pushViewController(viewController, animated: true)
         }
         
         public func showImageDetail(photo: UnsplashPhoto, allPhotos: [UnsplashPhoto]) {
             // Будет реализовано позже
         }
     }
     ```

6. **Создание GalleryViewModel**[7][20]:
   - В `ViewModel/` создайте `GalleryViewModel.swift`:
     ```swift
     import Foundation
     import Models
     import NetworkLayer
     import DataLayer
     import Combine
     
     @MainActor
     public final class GalleryViewModel: ObservableObject {
         @Published public var photos: [UnsplashPhoto] = []
         @Published public var isLoading = false
         @Published public var errorMessage: String?
         @Published public var favoriteIds: Set<String> = []
         
         private let unsplashService: UnsplashServiceProtocol
         private let favoritesUseCase: FavoritesUseCaseProtocol
         private weak var coordinator: GalleryCoordinatorProtocol?
         
         private var currentPage = 1
         private var canLoadMore = true
         
         public init(
             unsplashService: UnsplashServiceProtocol,
             favoritesUseCase: FavoritesUseCaseProtocol,
             coordinator: GalleryCoordinatorProtocol?
         ) {
             self.unsplashService = unsplashService
             self.favoritesUseCase = favoritesUseCase
             self.coordinator = coordinator
         }
         
         public func loadPhotos() async {
             guard !isLoading else { return }
             
             isLoading = true
             errorMessage = nil
             
             do {
                 let newPhotos = try await unsplashService.fetchPhotos(
                     page: currentPage,
                     perPage: 30
                 )
                 
                 if newPhotos.isEmpty {
                     canLoadMore = false
                 } else {
                     photos.append(contentsOf: newPhotos)
                     currentPage += 1
                 }
                 
                 // Обновляем избранное
                 favoriteIds = await favoritesUseCase.getFavorites()
                 
             } catch {
                 errorMessage = "Failed to load photos: \(error.localizedDescription)"
             }
             
             isLoading = false
         }
         
         public func isFavorite(photoId: String) -> Bool {
             return favoriteIds.contains(photoId)
         }
         
         public func didSelectPhoto(_ photo: UnsplashPhoto) {
             coordinator?.showImageDetail(photo: photo, allPhotos: photos)
         }
     }
     ```

7. **Коммит**[1]:
   - `git add Packages/GalleryFeature`
   - `git commit -m "[ADDED] GalleryFeature module with ViewModel and Coordinator"`
   - `git push origin feature/4.1-gallery-screen`

**Результат**: Структура модуля Gallery создана.

***

### Шаг 4.2: Создание GalleryViewController и Collection View

**Что делаем**: Создаем UI для экрана галереи с UICollectionView[1][32][33].

**Подробные действия**:

1. **Создание GalleryCell**[32][33]:
   - В `GalleryFeature/View/` создайте `GalleryCell.swift`:
     ```swift
     import UIKit
     import Core
     import Models
     
     final class GalleryCell: UICollectionViewCell {
         static let reuseIdentifier = "GalleryCell"
         
         private let imageView: UIImageView = {
             let iv = UIImageView()
             iv.contentMode = .scaleAspectFill
             iv.clipsToBounds = true
             iv.translatesAutoresizingMaskIntoConstraints = false
             return iv
         }()
         
         private let favoriteIcon: UIImageView = {
             let iv = UIImageView()
             iv.image = UIImage(systemName: "heart.fill")
             iv.tintColor = .systemRed
             iv.translatesAutoresizingMaskIntoConstraints = false
             iv.isHidden = true
             return iv
         }()
         
         override init(frame: CGRect) {
             super.init(frame: frame)
             setupUI()
         }
         
         required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
         
         private func setupUI() {
             contentView.addSubviews(imageView, favoriteIcon)
             
             NSLayoutConstraint.activate([
                 imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                 imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                 imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                 imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                 
                 favoriteIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                 favoriteIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                 favoriteIcon.widthAnchor.constraint(equalToConstant: 24),
                 favoriteIcon.heightAnchor.constraint(equalToConstant: 24)
             ])
         }
         
         func configure(with photo: UnsplashPhoto, isFavorite: Bool) {
             imageView.setImage(from: photo.urls.small)
             favoriteIcon.isHidden = !isFavorite
         }
         
         override func prepareForReuse() {
             super.prepareForReuse()
             imageView.image = nil
             favoriteIcon.isHidden = true
         }
     }
     ```

2. **Создание GalleryViewController**[32][33]:
   - В `View/` создайте `GalleryViewController.swift`:
     ```swift
     import UIKit
     import Combine
     
     public final class GalleryViewController: UIViewController {
         private let viewModel: GalleryViewModel
         private var cancellables = Set<AnyCancellable>()
         
         private lazy var collectionView: UICollectionView = {
             let layout = createLayout()
             let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
             cv.backgroundColor = .systemBackground
             cv.translatesAutoresizingMaskIntoConstraints = false
             cv.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.reuseIdentifier)
             cv.delegate = self
             cv.dataSource = self
             return cv
         }()
         
         private let activityIndicator: UIActivityIndicatorView = {
             let indicator = UIActivityIndicatorView(style: .large)
             indicator.translatesAutoresizingMaskIntoConstraints = false
             return indicator
         }()
         
         public init(viewModel: GalleryViewModel) {
             self.viewModel = viewModel
             super.init(nibName: nil, bundle: nil)
         }
         
         required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
         
         public override func viewDidLoad() {
             super.viewDidLoad()
             setupUI()
             bindViewModel()
             
             Task {
                 await viewModel.loadPhotos()
             }
         }
         
         private func setupUI() {
             title = "Gallery"
             view.backgroundColor = .systemBackground
             
             view.addSubview(collectionView)
             view.addSubview(activityIndicator)
             
             NSLayoutConstraint.activate([
                 collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                 collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                 collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                 collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                 
                 activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                 activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
             ])
         }
         
         private func createLayout() -> UICollectionViewLayout {
             let itemSize = NSCollectionLayoutSize(
                 widthDimension: .fractionalWidth(1.0/3.0),
                 heightDimension: .fractionalHeight(1.0)
             )
             let item = NSCollectionLayoutItem(layoutSize: itemSize)
             item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
             
             let groupSize = NSCollectionLayoutSize(
                 widthDimension: .fractionalWidth(1.0),
                 heightDimension: .fractionalWidth(1.0/3.0)
             )
             let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
             
             let section = NSCollectionLayoutSection(group: group)
             
             return UICollectionViewCompositionalLayout(section: section)
         }
         
         private func bindViewModel() {
             viewModel.$photos
                 .receive(on: DispatchQueue.main)
                 .sink { [weak self] _ in
                     self?.collectionView.reloadData()
                 }
                 .store(in: &cancellables)
             
             viewModel.$isLoading
                 .receive(on: DispatchQueue.main)
                 .sink { [weak self] isLoading in
                     if isLoading {
                         self?.activityIndicator.startAnimating()
                     } else {
                         self?.activityIndicator.stopAnimating()
                     }
                 }
                 .store(in: &cancellables)
             
             viewModel.$errorMessage
                 .receive(on: DispatchQueue.main)
                 .compactMap { $0 }
                 .sink { [weak self] message in
                     self?.showError(message)
                 }
                 .store(in: &cancellables)
         }
         
         private func showError(_ message: String) {
             let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default))
             present(alert, animated: true)
         }
     }
     
     // MARK: - UICollectionViewDataSource
     extension GalleryViewController: UICollectionViewDataSource {
         public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
             return viewModel.photos.count
         }
         
         public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
             guard let cell = collectionView.dequeueReusableCell(
                 withReuseIdentifier: GalleryCell.reuseIdentifier,
                 for: indexPath
             ) as? GalleryCell else {
                 return UICollectionViewCell()
             }
             
             let photo = viewModel.photos[indexPath.item]
             let isFavorite = viewModel.isFavorite(photoId: photo.id)
             cell.configure(with: photo, isFavorite: isFavorite)
             
             return cell
         }
     }
     
     // MARK: - UICollectionViewDelegate
     extension GalleryViewController: UICollectionViewDelegate {
         public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
             let photo = viewModel.photos[indexPath.item]
             viewModel.didSelectPhoto(photo)
         }
         
         public func scrollViewDidScroll(_ scrollView: UIScrollView) {
             let offsetY = scrollView.contentOffset.y
             let contentHeight = scrollView.contentSize.height
             let frameHeight = scrollView.frame.size.height
             
             if offsetY > contentHeight - frameHeight - 200 {
                 Task {
                     await viewModel.loadPhotos()
                 }
             }
         }
     }
     ```

3. **Коммит**[1]:
   - `git add .`
   - `git commit -m "[ADDED] GalleryViewController with UICollectionView grid layout"`
   - `git push origin feature/4.1-gallery-screen`

**Результат**: UI галереи создан с сеткой изображений.

***

### Шаг 4.3: Настройка навигации в AppDelegate

**Что делаем**: Настраиваем отображение Gallery экрана при запуске[29][30].

**Подробные действия**:

1. **Обновление SceneDelegate**[29]:
   - Откройте `App/SceneDelegate.swift`:
     ```swift
     import UIKit
     import GalleryFeature
     import NetworkLayer
     import DataLayer
     import Core
     
     class SceneDelegate: UIResponder, UIWindowSceneDelegate {
         var window: UIWindow?
         var appCoordinator: GalleryCoordinator?
         
         func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
             guard let windowScene = (scene as? UIWindowScene) else { return }
             
             let window = UIWindow(windowScene: windowScene)
             let navigationController = UINavigationController()
             
             // Dependency Injection
             let networkService = URLSessionNetworkService(
                 accessKey: Config.unsplashAccessKey
             )
             let unsplashService = UnsplashService(networkService: networkService)
             let favoritesRepository = UserDefaultsFavoritesRepository()
             let favoritesUseCase = FavoritesUseCase(repository: favoritesRepository)
             
             // Coordinator
             appCoordinator = GalleryCoordinator(navigationController: navigationController)
             appCoordinator?.start()
             
             window.rootViewController = navigationController
             self.window = window
             window.makeKeyAndVisible()
         }
     }
     ```

2. **Подключение GalleryFeature к проекту**:
   - Targets → GalleryApp → Frameworks → добавьте GalleryFeature

3. **Тест запуска**:
   - Запустите проект (Cmd+R)
   - Должен появиться экран Gallery с сеткой изображений из Unsplash

4. **Коммит**[1]:
   - `git add App/`
   - `git commit -m "[IMPLEMENTED] App navigation with GalleryCoordinator"`
   - `git push origin feature/4.1-gallery-screen`

5. **Завершение feature**[3]:
   - `git checkout develop`
   - `git merge feature/4.1-gallery-screen`
   - `git push origin develop`

**Результат**: Экран галереи отображается при запуске приложения.

***

## Фаза 5: Создание экрана Detail

### Шаг 5.1: Создание модуля DetailFeature

**Что делаем**: Создаем модуль для детального просмотра изображения[1].

**Подробные действия**:

1. **Создание feature-ветки**:
   - `git checkout develop`
   - `git checkout -b feature/5.1-detail-screen`

2. **Создание пакета DetailFeature**[2][16]:
   - File → New → Package → Library
   - Название: `DetailFeature`
   - Сохранить в `Packages/`

3. **Настройка Package.swift**:
   ```swift
   let package = Package(
       name: "DetailFeature",
       platforms: [.iOS(.v15)],
       products: [
           .library(name: "DetailFeature", targets: ["DetailFeature"]),
       ],
       dependencies: [
           .package(path: "../Models"),
           .package(path: "../Core"),
           .package(path: "../DataLayer")
       ],
       targets: [
           .target(
               name: "DetailFeature",
               dependencies: ["Models", "Core", "DataLayer"]),
       ]
   )
   ```

4. **Создание DetailViewModel**[7][20]:
   - В `Sources/DetailFeature/` создайте `DetailViewModel.swift`:
     ```swift
     import Foundation
     import Models
     import DataLayer
     import Combine
     
     @MainActor
     public final class DetailViewModel: ObservableObject {
         @Published public var currentPhoto: UnsplashPhoto
         @Published public var isFavorite: Bool = false
         
         public let allPhotos: [UnsplashPhoto]
         private let favoritesUseCase: FavoritesUseCaseProtocol
         
         public init(
             photo: UnsplashPhoto,
             allPhotos: [UnsplashPhoto],
             favoritesUseCase: FavoritesUseCaseProtocol
         ) {
             self.currentPhoto = photo
             self.allPhotos = allPhotos
             self.favoritesUseCase = favoritesUseCase
             
             Task {
                 await checkFavoriteStatus()
             }
         }
         
         public func toggleFavorite() async {
             do {
                 try await favoritesUseCase.toggleFavorite(photoId: currentPhoto.id)
                 await checkFavoriteStatus()
             } catch {
                 print("Failed to toggle favorite: \(error)")
             }
         }
         
         private func checkFavoriteStatus() async {
             isFavorite = await favoritesUseCase.isFavorite(photoId: currentPhoto.id)
         }
         
         public func moveToNextPhoto() {
             guard let currentIndex = allPhotos.firstIndex(where: { $0.id == currentPhoto.id }),
                   currentIndex < allPhotos.count - 1 else { return }
             
             currentPhoto = allPhotos[currentIndex + 1]
             Task {
                 await checkFavoriteStatus()
             }
         }
         
         public func moveToPreviousPhoto() {
             guard let currentIndex = allPhotos.firstIndex(where: { $0.id == currentPhoto.id }),
                   currentIndex > 0 else { return }
             
             currentPhoto = allPhotos[currentIndex - 1]
             Task {
                 await checkFavoriteStatus()
             }
         }
     }
     ```

5. **Создание DetailViewController**[1]:
   - Создайте `DetailViewController.swift`:
     ```swift
     import UIKit
     import Core
     import Combine
     
     public final class DetailViewController: UIViewController {
         private let viewModel: DetailViewModel
         private var cancellables = Set<AnyCancellable>()
         
         private let scrollView: UIScrollView = {
             let sv = UIScrollView()
             sv.translatesAutoresizingMaskIntoConstraints = false
             sv.minimumZoomScale = 1.0
             sv.maximumZoomScale = 3.0
             return sv
         }()
         
         private let imageView: UIImageView = {
             let iv = UIImageView()
             iv.contentMode = .scaleAspectFit
             iv.translatesAutoresizingMaskIntoConstraints = false
             return iv
         }()
         
         private let titleLabel: UILabel = {
             let label = UILabel()
             label.font = .systemFont(ofSize: 18, weight: .semibold)
             label.numberOfLines = 2
             label.translatesAutoresizingMaskIntoConstraints = false
             return label
         }()
         
         private let descriptionLabel: UILabel = {
             let label = UILabel()
             label.font = .systemFont(ofSize: 14)
             label.numberOfLines = 0
             label.textColor = .secondaryLabel
             label.translatesAutoresizingMaskIntoConstraints = false
             return label
         }()
         
         private lazy var favoriteButton: UIButton = {
             let button = UIButton(type: .system)
             button.translatesAutoresizingMaskIntoConstraints = false
             button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
             return button
         }()
         
         public init(viewModel: DetailViewModel) {
             self.viewModel = viewModel
             super.init(nibName: nil, bundle: nil)
         }
         
         required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
         
         public override func viewDidLoad() {
             super.viewDidLoad()
             setupUI()
             setupGestures()
             bindViewModel()
         }
         
         private func setupUI() {
             view.backgroundColor = .systemBackground
             
             scrollView.delegate = self
             scrollView.addSubview(imageView)
             
             view.addSubview(scrollView)
             view.addSubview(titleLabel)
             view.addSubview(descriptionLabel)
             view.addSubview(favoriteButton)
             
             NSLayoutConstraint.activate([
                 scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                 scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                 scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                 scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
                 
                 imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                 imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                 imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                 imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                 imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                 imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                 
                 favoriteButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
                 favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                 favoriteButton.widthAnchor.constraint(equalToConstant: 44),
                 favoriteButton.heightAnchor.constraint(equalToConstant: 44),
                 
                 titleLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
                 titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                 titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
                 
                 descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                 descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                 descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
             ])
         }
         
         private func setupGestures() {
             let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
             swipeLeft.direction = .left
             view.addGestureRecognizer(swipeLeft)
             
             let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
             swipeRight.direction = .right
             view.addGestureRecognizer(swipeRight)
         }
         
         private func bindViewModel() {
             viewModel.$currentPhoto
                 .receive(on: DispatchQueue.main)
                 .sink { [weak self] photo in
                     self?.updateUI(with: photo)
                 }
                 .store(in: &cancellables)
             
             viewModel.$isFavorite
                 .receive(on: DispatchQueue.main)
                 .sink { [weak self] isFavorite in
                     self?.updateFavoriteButton(isFavorite: isFavorite)
                 }
                 .store(in: &cancellables)
         }
         
         private func updateUI(with photo: UnsplashPhoto) {
             imageView.setImage(from: photo.urls.regular)
             titleLabel.text = photo.user?.name ?? "Unknown"
             descriptionLabel.text = photo.description ?? photo.altDescription ?? "No description"
         }
         
         private func updateFavoriteButton(isFavorite: Bool) {
             let imageName = isFavorite ? "heart.fill" : "heart"
             let image = UIImage(systemName: imageName)
             favoriteButton.setImage(image, for: .normal)
             favoriteButton.tintColor = isFavorite ? .systemRed : .systemGray
         }
         
         @objc private func favoriteButtonTapped() {
             Task {
                 await viewModel.toggleFavorite()
             }
         }
         
         @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
             if gesture.direction == .left {
                 viewModel.moveToNextPhoto()
             } else if gesture.direction == .right {
                 viewModel.moveToPreviousPhoto()
             }
         }
     }
     
     extension DetailViewController: UIScrollViewDelegate {
         public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
             return imageView
         }
     }
     ```

6. **Обновление GalleryCoordinator**:
   - Откройте `Packages/GalleryFeature/Sources/GalleryFeature/Coordinator/GalleryCoordinator.swift`:
   - Импортируйте DetailFeature
   - Реализуйте метод showImageDetail:
     ```swift
     import DetailFeature
     import DataLayer
     
     public func showImageDetail(photo: UnsplashPhoto, allPhotos: [UnsplashPhoto]) {
         let favoritesRepository = UserDefaultsFavoritesRepository()
         let favoritesUseCase = FavoritesUseCase(repository: favoritesRepository)
         
         let viewModel = DetailViewModel(
             photo: photo,
             allPhotos: allPhotos,
             favoritesUseCase: favoritesUseCase
         )
         let viewController = DetailViewController(viewModel: viewModel)
         
         navigationController?.pushViewController(viewController, animated: true)
     }
     ```

7. **Подключение DetailFeature к проекту**:
   - Targets → GalleryApp → Frameworks → добавьте DetailFeature

8. **Тест навигации**:
   - Запустите проект
   - Нажмите на любое изображение в галерее
   - Должен открыться экран деталей

9. **Коммит**[1]:
   - `git add .`
   - `git commit -m "[ADDED] DetailFeature with swipe gestures and favorite toggle"`
   - `git push origin feature/5.1-detail-screen`

10. **Завершение feature**[3]:
    - `git checkout develop`
    - `git merge feature/5.1-detail-screen`
    - `git push origin develop`

**Результат**: Экран деталей полностью функционален.

***

## Фаза 6: Финальная полировка

### Шаг 6.1: Обработка ошибок и улучшение UX

**Что делаем**: Добавляем централизованную обработку ошибок и улучшаем UI[1][19].

**Подробные действия**:

1. **Создание feature-ветки**:
   - `git checkout develop`
   - `git checkout -b feature/6.1-polish`

2. **Создание Error Handler в Core**[19]:
   - В Core создайте `ErrorHandler.swift`:
     ```swift
     import Foundation
     
     public enum AppError: Error {
         case network(NetworkError)
         case dataStorage(Error)
         case unknown(Error)
         
         public var localizedDescription: String {
             switch self {
             case .network(let error):
                 return "Network error: \(error.localizedDescription)"
             case .dataStorage(let error):
                 return "Storage error: \(error.localizedDescription)"
             case .unknown(let error):
                 return "Unknown error: \(error.localizedDescription)"
             }
         }
     }
     ```

3. **Добавление Pull-to-Refresh в Gallery**:
   - В `GalleryViewController`:
     ```swift
     private lazy var refreshControl: UIRefreshControl = {
         let rc = UIRefreshControl()
         rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
         return rc
     }()
     
     // В setupUI():
     collectionView.refreshControl = refreshControl
     
     @objc private func refreshData() {
         Task {
             await viewModel.refreshPhotos()
             refreshControl.endRefreshing()
         }
     }
     ```

4. **Обновление GalleryViewModel**:
   ```swift
   public func refreshPhotos() async {
       currentPage = 1
       photos = []
       canLoadMore = true
       await loadPhotos()
   }
   ```

5. **Добавление Empty State**:
   - В `GalleryViewController` добавьте:
     ```swift
     private let emptyStateLabel: UILabel = {
         let label = UILabel()
         label.text = "No photos yet.\nPull to refresh!"
         label.numberOfLines = 0
         label.textAlignment = .center
         label.textColor = .secondaryLabel
         label.isHidden = true
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
     
     // В bindViewModel добавьте:
     viewModel.$photos
         .receive(on: DispatchQueue.main)
         .sink { [weak self] photos in
             self?.collectionView.reloadData()
             self?.emptyStateLabel.isHidden = !photos.isEmpty
         }
         .store(in: &cancellables)
     ```

6. **Коммит**[1]:
   - `git add .`
   - `git commit -m "[IMPROVED] Error handling and UX with pull-to-refresh and empty state"`
   - `git push origin feature/6.1-polish`

**Результат**: Приложение имеет улучшенную обработку ошибок и UX.

***

### Шаг 6.2: Написание Unit-тестов

**Что делаем**: Добавляем юнит-тесты для критичных компонентов[1][7].

**Подробные действия**:

1. **Создание тестов для GalleryViewModel**:
   - В `Packages/GalleryFeature/Tests/GalleryFeatureTests/`:
     ```swift
     import XCTest
     @testable import GalleryFeature
     import Models
     import NetworkLayer
     import DataLayer
     
     @MainActor
     final class GalleryViewModelTests: XCTestCase {
         var sut: GalleryViewModel!
         var mockUnsplashService: MockUnsplashService!
         var mockFavoritesUseCase: MockFavoritesUseCase!
         
         override func setUp() {
             super.setUp()
             mockUnsplashService = MockUnsplashService()
             mockFavoritesUseCase = MockFavoritesUseCase()
             sut = GalleryViewModel(
                 unsplashService: mockUnsplashService,
                 favoritesUseCase: mockFavoritesUseCase,
                 coordinator: nil
             )
         }
         
         func testLoadPhotos_Success() async {
             // Given
             mockUnsplashService.mockPhotos = [createMockPhoto()]
             
             // When
             await sut.loadPhotos()
             
             // Then
             XCTAssertEqual(sut.photos.count, 1)
             XCTAssertFalse(sut.isLoading)
             XCTAssertNil(sut.errorMessage)
         }
         
         func testLoadPhotos_Failure() async {
             // Given
             mockUnsplashService.shouldFail = true
             
             // When
             await sut.loadPhotos()
             
             // Then
             XCTAssertTrue(sut.photos.isEmpty)
             XCTAssertNotNil(sut.errorMessage)
         }
         
         private func createMockPhoto() -> UnsplashPhoto {
             UnsplashPhoto(
                 id: "1",
                 createdAt: nil,
                 width: 1000,
                 height: 1000,
                 color: "#000",
                 description: "Test",
                 altDescription: nil,
                 urls: PhotoURLs(raw: "", full: "", regular: "", small: "", thumb: ""),
                 user: nil
             )
         }
     }
     
     // Mock classes
     final class MockUnsplashService: UnsplashServiceProtocol {
         var mockPhotos: [UnsplashPhoto] = []
         var shouldFail = false
         
         func fetchPhotos(page: Int, perPage: Int) async throws -> [UnsplashPhoto] {
             if shouldFail {
                 throw NetworkError.unknown
             }
             return mockPhotos
         }
     }
     
     final class MockFavoritesUseCase: FavoritesUseCaseProtocol {
         var favorites: Set<String> = []
         
         func toggleFavorite(photoId: String) async throws {
             if favorites.contains(photoId) {
                 favorites.remove(photoId)
             } else {
                 favorites.insert(photoId)
             }
         }
         
         func isFavorite(photoId: String) async -> Bool {
             return favorites.contains(photoId)
         }
         
         func getFavorites() async -> Set<String> {
             return favorites
         }
     }
     ```

2. **Запуск всех тестов**:
   - Product → Test (Cmd+U)
   - Убедитесь, что все тесты проходят

3. **Коммит**[1]:
   - `git add .`
   - `git commit -m "[ADDED] Unit tests for GalleryViewModel and DataLayer"`
   - `git push origin feature/6.1-polish`

**Результат**: Критичные компоненты покрыты тестами.

***

### Шаг 6.3: Проверка SOLID принципов

**Что делаем**: Проверяем соблюдение SOLID принципов в коде[1][19][34][35].

**Подробные действия**:

1. **Создайте документ ARCHITECTURE.md**[19]:
   ```markdown
   # Архитектурные решения и SOLID принципы
   
   ## Single Responsibility Principle (SRP)
   - **GalleryViewController** отвечает только за отображение UI
   - **GalleryViewModel** управляет бизнес-логикой
   - **UnsplashService** отвечает только за сетевые запросы
   - **FavoritesRepository** управляет только хранением избранного
   
   ## Open/Closed Principle (OCP)
   - Использование протоколов позволяет расширять функционал без изменения существующего кода
   - Например, можно легко заменить `UserDefaultsFavoritesRepository` на `CoreDataRepository`
   
   ## Liskov Substitution Principle (LSP)
   - Все реализации `NetworkService` взаимозаменяемы
   - `MockNetworkService` в тестах заменяет `URLSessionNetworkService`
   
   ## Interface Segregation Principle (ISP)
   - Протоколы разделены по функциям:
     - `UnsplashServiceProtocol` - только для работы с API
     - `FavoritesUseCaseProtocol` - только для избранного
   
   ## Dependency Inversion Principle (DIP)
   - Все модули зависят от протоколов, а не от конкретных реализаций
   - Dependency Injection через инициализаторы
   ```

2. **Финальный рефакторинг**[19]:
   - Проверьте, что все классы следуют SRP
   - Убедитесь, что зависимости инжектятся через протоколы

3. **Коммит**[1]:
   - `git add ARCHITECTURE.md`
   - `git commit -m "[DOCS] Added SOLID principles documentation"`
   - `git push origin feature/6.1-polish`

4. **Завершение feature**[3]:
   - `git checkout develop`
   - `git merge feature/6.1-polish`
   - `git push origin develop`

**Результат**: Код соответствует SOLID принципам.

***

## Фаза 7: Документация и подготовка к сабмиту

### Шаг 7.1: Создание README

**Что делаем**: Создаем подробный README с инструкциями[1].

**Подробные действия**:

1. **Создание feature-ветки**:
   - `git checkout develop`
   - `git checkout -b feature/7.1-documentation`

2. **Обновление README.md**[1]:
   ```markdown
   # 🖼️ iOS Gallery App
   
   Приложение-галерея для просмотра изображений из Unsplash API с возможностью сохранения избранного.
   
   ## 👨‍💻 Контакты
   - **Имя**: [Ваше имя]
   - **Email**: your.email@example.com
   - **GitHub**: https://github.com/yourusername
   - **LinkedIn**: https://linkedin.com/in/yourprofile
   
   ## 📱 О проекте
   
   Тестовое задание для позиции iOS разработчика. Приложение демонстрирует:
   - Работу с Unsplash API
   - MVVM + Clean Architecture
   - Модульную структуру на Swift Package Manager
   - Локальное сохранение данных
   - UIKit и программное создание UI
   
   ## ✨ Основные функции
   
   - 📸 Просмотр фотографий из Unsplash в виде сетки
   - ♾️ Бесконечная пагинация (30 фото на запрос)
   - ❤️ Добавление фото в избранное
   - 🔍 Детальный просмотр с zoom
   - 👆 Swipe-жесты для навигации между фото
   - 💾 Кэширование изображений
   - 🔄 Pull-to-refresh
   
   ## 🏗️ Архитектура
   
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
   
   ## 🚀 Установка и запуск
   
   ### Требования:
   - Xcode 15.0+
   - iOS 15.0+
   - Swift 5.9+
   
   ### Инструкция:
   
   1. Клонируйте репозиторий:
      ```
      git clone git@github.com:yourusername/ios-gallery-app.git
      cd ios-gallery-app
      ```
   
   2. Получите Unsplash API ключ:
      - Зарегистрируйтесь на https://unsplash.com/developers
      - Создайте приложение
      - Скопируйте Access Key
   
   3. Настройте Config файл:
      ```
      cp Config.xcconfig.example Config.xcconfig
      ```
      Откройте `Config.xcconfig` и вставьте ваш API ключ:
      ```
      UNSPLASH_ACCESS_KEY = your_access_key_here
      ```
   
   4. Откройте проект в Xcode:
      ```
      open GalleryApp.xcodeproj
      ```
   
   5. Запустите проект (⌘R)
   
   ## 📸 Скриншоты
   
   [Здесь будут скриншоты]
   
   ## 🎥 Демо
   
   [Ссылка на видео]
   
   ## 🧪 Тестирование
   
   Запуск тестов:
   ```
   xcodebuild test -scheme GalleryApp -destination 'platform=iOS Simulator,name=iPhone 15'
   ```
   
   Или в Xcode: Product → Test (⌘U)
   
   ## 📝 Git Workflow
   
   Проект использует Git Flow:
   - `main` — стабильная версия
   - `develop` — основная ветка разработки
   - `feature/*` — ветки для отдельных задач
   
   ### Conventional Commits:
   - `[ADDED]` — новая функциональность
   - `[FIXED]` — исправление бага
   - `[REFACTORED]` — рефакторинг кода
   - `[UPDATED]` — обновление существующей функции
   
   ## 🔮 Дополнительные фичи
   
   - Pull-to-refresh для обновления списка
   - Empty state при отсутствии фотографий
   - Zoom для детального просмотра
   - Индикаторы загрузки
   - Обработка ошибок сети
   
   ## 📄 Лицензия
   
   MIT License
   
   ## 🙏 Благодарности
   
   - [Unsplash](https://unsplash.com) за бесплатный API
   - [Kingfisher](https://github.com/onevcat/Kingfisher) за кэширование изображений
   ```

3. **Коммит README**[1]:
   - `git add README.md`
   - `git commit -m "[UPDATED] Comprehensive README with setup instructions"`
   - `git push origin feature/7.1-documentation`

**Результат**: Подробный README создан.

***

### Шаг 7.2: Создание скриншотов

**Что делаем**: Делаем скриншоты приложения для README[1].

**Подробные действия**:

1. **Запуск симулятора**:
   - Выберите iPhone 15 Pro
   - Запустите приложение (Cmd+R)

2. **Создание скриншотов**:
   - В симуляторе: File → Take Screenshot (или Cmd+S)
   - Сделайте скриншоты:
     - Главный экран с галереей
     - Экран деталей
     - Экран с избранным изображением (сердечко)

3. **Добавление в репозиторий**:
   - Создайте папку `Screenshots/` в корне проекта
   - Поместите туда скриншоты
   - Переименуйте: `gallery_screen.png`, `detail_screen.png`

4. **Обновление README**:
   ```markdown
   ## 📸 Скриншоты
   
   ### Экран галереи
   ![Gallery Screen](Screenshots/gallery_screen.png)
   
   ### Экран деталей
   ![Detail Screen](Screenshots/detail_screen.png)
   ```

5. **Коммит**[1]:
   - `git add Screenshots/ README.md`
   - `git commit -m "[ADDED] Screenshots for README"`
   - `git push origin feature/7.1-documentation`

**Результат**: Визуальная документация добавлена.

***

### Шаг 7.3: Финальная проверка

**Что делаем**: Проверяем все требования тестового задания[1].

**Подробные действия**:

1. **Создайте чек-лист в CHECKLIST.md**[1]:
   ```markdown
   # Чек-лист требований
   
   ## Функциональные требования
   - [x] Два экрана: Gallery и Detail
   - [x] Сетка изображений с thumbnails
   - [x] Пагинация (30 фото на запрос)
   - [x] Локальное сохранение избранного
   - [x] Индикатор избранного на thumbnails
   - [x] Swipe-жесты для навигации
   - [x] Детальный просмотр с title и description
   - [x] Кнопка добавления в избранное
   
   ## Технические требования
   - [x] Swift
   - [x] iOS 15+
   - [x] UIKit
   - [x] URLSession
   - [x] Unsplash API
   - [x] MV(x) архитектура (MVVM + Clean)
   - [x] SOLID принципы
   - [x] SwiftLint
   - [x] .gitignore
   - [x] Conventional commits
   - [x] README с инструкциями
   - [x] Unit тесты
   - [x] Модульная структура
   
   ## Дополнительно
   - [x] Coordinator pattern
   - [x] Pull-to-refresh
   - [x] Image caching (Kingfisher)
   - [x] Error handling
   - [x] Empty states
   - [x] Loading indicators
   ```

2. **Запуск финальной проверки**:
   - Запустите все тесты: Product → Test (Cmd+U)
   - Запустите приложение на разных симуляторах
   - Проверьте работу на iOS 15 и iOS 17
   - Проверьте работу в портретной и альбомной ориентации

3. **Запуск SwiftLint**:
   - В терминале: `swiftlint`
   - Исправьте все ошибки

4. **Финальные коммиты**[1]:
   - `git add CHECKLIST.md`
   - `git commit -m "[DOCS] Added requirements checklist"`
   - `git push origin feature/7.1-documentation`

5. **Merge в develop и main**[3]:
   - `git checkout develop`
   - `git merge feature/7.1-documentation`
   - `git push origin develop`
   - `git checkout main`
   - `git merge develop`
   - `git push origin main`
   - Создайте тег: `git tag v1.0.0`
   - `git push origin v1.0.0`

**Результат**: Проект полностью готов к сабмиту.

***

## Заключение

Поздравляю! Вы успешно завершили разработку iOS Gallery App. Проект демонстрирует:

- ✅ **Модульную архитектуру** на базе Swift Package Manager[2][16][17]
- ✅ **Clean Architecture** с разделением на слои[7][20]
- ✅ **MVVM паттерн** с Coordinator для навигации[7][29][30]
- ✅ **SOLID принципы** на практике[19][34][35]
- ✅ **Git Flow** с structured commit history[3][4][5]
- ✅ **Качественный код** с SwiftLint и тестами[12][13]

Теперь вы можете отправить ссылку на репозиторий работодателю. Убедитесь, что репозиторий публичный и README содержит все необходимые инструкции[1].

**Следующие шаги**:
1. Создайте Release на GitHub с тегом v1.0.0
2. Добавьте ссылку на репозиторий в ваше резюме
3. Подготовьте короткую презентацию проекта (3-5 минут)
4. Будьте готовы объяснить архитектурные решения и применение SOLID принципов

Удачи на собеседовании! 🚀

Sources
[1] Mobile-iOS-Gallery-App-Trainee-task-v2.0.2-1.pdf https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/94591289/3d0a3fea-06e4-4821-940b-2ad223bf5ae2/Mobile-iOS-Gallery-App-Trainee-task-v2.0.2-1.pdf
[2] Modularizing iOS Applications with SwiftUI and Swift ... https://nimblehq.co/blog/modern-approach-modularize-ios-swiftui-spm
[3] 6 Types of Git Branching Strategy for DevOps https://dev.to/juniourrau/6-types-of-git-branching-strategy-g54
[4] Gitflow Workflow | Atlassian Git Tutorial https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow
[5] A successful Git branching model https://nvie.com/posts/a-successful-git-branching-model/
[6] List.md https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/94591289/37b52ec8-2681-4ada-ac82-f646896c80a9/List.md
[7] denissimon/iOS-MVVM-Clean-Architecture https://github.com/denissimon/iOS-MVVM-Clean-Architecture
[8] Best Way To Structure Your Xcode Project | by Emin Emini https://betterprogramming.pub/best-way-to-structure-your-xcode-project-23327999fdc5
[9] Best practices when it comes to organizing an Xcode project https://www.reddit.com/r/swift/comments/1dwywz9/best_practices_when_it_comes_to_organizing_an/
[10] Part 2: Structure Your Folders in Xcode | by Ai-Lyn Tang https://code.likeagirl.io/how-to-structure-your-folders-9f9c003e46d
[11] Best practice for an Xcode project groups structure? https://stackoverflow.com/questions/39945727/best-practice-for-an-xcode-project-groups-structure
[12] How to add a pre-commit githook script during the build ... https://www.delasign.com/blog/xcode-add-precommit-githook-script-on-build/
[13] Run swiftlint in pre-commit hook - samwize https://samwize.com/2022/04/22/run-swiftlint-in-pre-commit-hook/
[14] Swiftlint as pre-commit git hook · Issue #785 https://github.com/realm/SwiftLint/issues/785
[15] Git Hooks 🤝 Swift @ SwiftToolkit.dev https://www.swifttoolkit.dev/posts/git-hooks
[16] How to modularize projects with Swift Package Manager https://decode.agency/article/project-modularization-swift-package-manager/
[17] Scaling Swift Projects with Modular Packages https://swiftly-developed.com/blog/scaling-swift-projects-with-modular-packages
[18] iOS Application Modularization https://mentorcruise.com/blog/ios-application-modularization/
[19] SOLID Principles for iOS Apps https://www.kodeco.com/21503974-solid-principles-for-ios-apps
[20] Clean Architecture and MVVM on iOS | by Oleh Kudinov https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3
[21] Working with url session to use the Unsplash API : r/SwiftUI https://www.reddit.com/r/SwiftUI/comments/kjb0jg/working_with_url_session_to_use_the_unsplash_api/
[22] Unsplash Image API | Free HD Photo API https://unsplash.com/developers
[23] Unsplash API Documentation | Free HD Photo API https://unsplash.com/documentation
[24] Using Persistent History Tracking in CoreData https://fatbobman.com/en/posts/persistenthistorytracking/
[25] Repository pattern using Core Data and Swift https://oceanobe.com/news/repository-pattern-using-core-data-and-swift/54
[26] Kingfisher vs SDWebImage · Issue #12 https://github.com/onevcat/Kingfisher/issues/12
[27] Loading images asynchronously – iOS & Swift Example https://www.ralfebert.com/ios/examples/async-image-loading/
[28] Which is your preferred image loading library ... https://www.reddit.com/r/iOSProgramming/comments/m7vn6a/which_is_your_preferred_image_loading_library/
[29] Mastering iOS Navigation: Coordinators, ViewCoordinators ... https://blog.ravn.co/mastering-ios-navigation-coordinators-viewcoordinators-and-routers/
[30] QuickBirdEng/XCoordinator https://github.com/QuickBirdEng/XCoordinator
[31] iOS Swift Coordinator pattern and back button of ... https://stackoverflow.com/questions/54156384/ios-swift-coordinator-pattern-and-back-button-of-navigation-controller
[32] iOS Swift UICollectionView with Horizontal Pagination https://dzone.com/articles/ios-swift-uicollectionview-with-horizontal-paginat
[33] Implementing modern collection views https://developer.apple.com/documentation/UIKit/implementing-modern-collection-views
[34] An easy and simple explanation of SOLID principles with ... https://gist.github.com/mjhassan/2a61c16c68d66fd43f24306a07900bc6
[35] iOS Swift S.O.L.I.D. Principles https://www.linkedin.com/pulse/ios-swift-solid-principles-munendra-pratap-singh
[36] Adopt a Git branching strategy - Azure Repos https://learn.microsoft.com/en-us/azure/devops/repos/git/git-branching-guidance?view=azure-devops
[37] Modular structure using SPM : r/iOSProgramming https://www.reddit.com/r/iOSProgramming/comments/1aqnvg2/modular_structure_using_spm/
[38] A Tale of Modular Architecture with SPM Swift Package ... https://www.youtube.com/watch?v=OBTr2imN0_w
[39] Gitflow branching strategy - AWS Prescriptive Guidance https://docs.aws.amazon.com/prescriptive-guidance/latest/choosing-git-branch-approach/gitflow-branching-strategy.html
[40] Swiftlint pre-commit hook https://gist.github.com/alielsokary/648194fd7a3862207ba9b7433bd12deb
[41] Swift Package Manager: Building a Modular, Scalable iOS ... https://blog.stackademic.com/swift-package-manager-building-a-modular-scalable-ios-architecture-22b2fc4d923a
[42] What Is GitFlow Branching Strategy? : r/programming https://www.reddit.com/r/programming/comments/198qxrk/what_is_gitflow_branching_strategy/
[43] Using pre-commit for Linters/Formatters - Thuyen's corner https://trinhngocthuyen.com/posts/tech/pre-commit/
[44] CyrilCermak/modular_architecture_on_ios https://github.com/CyrilCermak/modular_architecture_on_ios
[45] GitFlow Tutorial: Branching for Features, Releases, and ... https://www.datacamp.com/tutorial/gitflow
[46] Mobile App Development: MVVM, Clean Architecture & More https://www.fastdev.com/blog/blog/building-maintainable-mobile-apps/
[47] How To Use an API - Unsplash! (Swift | Xcode) https://www.youtube.com/watch?v=CmOe9vNopjU
[48] Clean MVVM architecture : r/iOSProgramming https://www.reddit.com/r/iOSProgramming/comments/1asl76l/clean_mvvm_architecture/
[49] The SOLID Principles with Practical Examples in Swift https://stackademic.com/blog/the-solid-principles-with-practical-examples-in-ios-swift
[50] dinhquan/iOSCleanArchitecture: iOS Clean Architecture ... https://github.com/dinhquan/iOSCleanArchitecture
[51] iOS Development Best Practices: SOLID Principles https://maddevs.io/blog/solid-principles-in-ios-development/
[52] async request to Unsplash api not working correctly https://stackoverflow.com/questions/68512063/async-request-to-unsplash-api-not-working-correctly
[53] 28 - UIKit Architecture - Curated iOS - Substack https://curatedios.substack.com/p/28-uikit-architecture
[54] Enhance Your Code Architecture With SOLID Principles ... https://hackernoon.com/enhance-your-code-architecture-with-solid-principles-with-swift-examples
[55] Unsplash-Swift on CocoaPods.org https://cocoapods.org/pods/Unsplash-Swift
[56] Why MVVM Alone Isn't Enough for Complex iOS UIKit ... https://www.linkedin.com/pulse/why-mvvm-alone-isnt-enough-complex-ios-uikit-projects-priyanshu-singh-9wo7f
[57] SOLID Principles for iOS Developers https://www.youtube.com/watch?v=YJ0o7r_6qZI
[58] SwiftData: Simplifying Persistence in iOS Apps https://www.kodeco.com/40504096-swiftdata-simplifying-persistence-in-ios-apps
[59] UICollectionView with paging - setting page width https://stackoverflow.com/questions/20496850/uicollectionview-with-paging-setting-page-width
[60] Modernizing a Legacy Modular iOS Codebase https://dev.to/vnayak_hejib/modernizing-a-legacy-modular-ios-codebase-3m10
[61] akxo/paging-collection-view-layout https://github.com/akxo/paging-collection-view-layout
[62] How to Structure a Scalable iOS App with Modular Architecture https://swift-pal.com/how-to-structure-a-scalable-ios-app-with-modular-architecture-b0130da83bca
[63] Simple way to do data persistence across devices : r/SwiftUI https://www.reddit.com/r/SwiftUI/comments/le3xby/simple_way_to_do_data_persistence_across_devices/
[64] Simple Modularization setup for a New App https://manu.show/2025-02-27-simple-modularization-setup/
[65] How to Save and Manage Data with Core Data in Swift https://www.youtube.com/watch?v=nTcrzJ49m-U
[66] Getting Started with UI​Collection​View​Compositional​ ... https://lickability.com/blog/getting-started-with-uicollectionviewcompositionallayout/
[67] Persist different objects (types) as single object - CoreData https://stackoverflow.com/questions/17210423/persist-different-objects-types-as-single-object-coredata-favorites-examp
[68] CollectionView Paging Layout for SwiftUI and ... https://www.youtube.com/watch?v=r29-06lbLmQ
[69] Kotlin Multiplatform — How to improve the iOS ... https://proandroiddev.com/kotlin-multiplatform-how-to-improve-the-ios-development-experience-fa8cb2c1aa92
[70] iOS Persistence and Core Data https://www.my-mooc.com/en/mooc/ios-persistence-and-core-data--ud325-fc8b9442-70d7-4f2c-b9e0-e5af586e6143
[71] Lightweight Design Patterns in iOS (Part 3) - Coordinator https://jhandguy.github.io/posts/coordinator-design-pattern-ios/
[72] Kingfisher vs SDWebImage - Awesome iOS - LibHunt https://ios.libhunt.com/compare-kingfisher-vs-sdwebimage
[73] Xcode 16's New Folder Format Explained! No More Merge ... https://www.youtube.com/watch?v=z94vpBgj0HY
[74] SwiftUI Navigation: Coordinator vs NavigationStack? : r/swift https://www.reddit.com/r/swift/comments/1l1flmz/swiftui_navigation_coordinator_vs_navigationstack/
[75] Simple IOS Image Caching Technique (Without Using Any ... https://1billiontech.com/blog_simple_IOS_image_caching_technique.php
[76] Managing files and folders in your Xcode project https://developer.apple.com/documentation/xcode/managing-files-and-folders-in-your-xcode-project
[77] /swiftui-refactor-navigation-layer-using-coordinator-pattern https://www.tiagohenriques.dev/blog/swiftui-refactor-navigation-layer-using-coordinator-pattern
[78] SDWebImage vs Kingfisher - Awesome iOS - LibHunt https://ios.libhunt.com/compare-sdwebimage-vs-kingfisher
[79] The best way to organize your Xcode projects https://www.youtube.com/watch?v=QG4GTiIR0ms
[80] Swift Tutorial: How to use Coordinator Pattern with MVVM https://www.youtube.com/watch?v=wpw3l_jTuOo
