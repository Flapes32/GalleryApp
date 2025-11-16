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
