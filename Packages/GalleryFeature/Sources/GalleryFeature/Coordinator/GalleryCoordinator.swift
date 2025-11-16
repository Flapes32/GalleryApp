import UIKit
import Models
import NetworkLayer
import DataLayer

public protocol GalleryCoordinatorProtocol: AnyObject {
    func showImageDetail(photo: UnsplashPhoto, allPhotos: [UnsplashPhoto])
}

public final class GalleryCoordinator: GalleryCoordinatorProtocol {
    private weak var navigationController: UINavigationController?
    private let unsplashService: UnsplashServiceProtocol
    private let favoritesUseCase: FavoritesUseCaseProtocol

    public init(
        navigationController: UINavigationController?,
        unsplashService: UnsplashServiceProtocol,
        favoritesUseCase: FavoritesUseCaseProtocol
    ) {
        self.navigationController = navigationController
        self.unsplashService = unsplashService
        self.favoritesUseCase = favoritesUseCase
    }

    public func start() {
        let viewModel = GalleryViewModel(
            unsplashService: unsplashService,
            favoritesUseCase: favoritesUseCase,
            coordinator: self
        )
        let viewController = GalleryViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }

    public func showImageDetail(photo: UnsplashPhoto, allPhotos: [UnsplashPhoto]) {
        // Будет реализовано позже
    }
}
