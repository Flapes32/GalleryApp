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
