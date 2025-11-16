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

