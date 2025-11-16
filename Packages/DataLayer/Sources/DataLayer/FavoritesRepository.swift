import Foundation

public protocol FavoritesRepository {
    func addToFavorites(photoId: String) async throws
    func removeFromFavorites(photoId: String) async throws
    func isFavorite(photoId: String) async -> Bool
    func getAllFavorites() async -> Set<String>
}
