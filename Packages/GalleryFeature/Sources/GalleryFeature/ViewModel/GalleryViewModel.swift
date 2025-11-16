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

