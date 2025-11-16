import UIKit
import Models
import NetworkLayer
import DataLayer
import DetailFeature

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

    @MainActor
    public func start() {
        let viewModel = GalleryViewModel(
            unsplashService: unsplashService,
            favoritesUseCase: favoritesUseCase,
            coordinator: self
        )
        let viewController = GalleryViewController(viewModel: viewModel)
        navigationController?.setViewControllers([viewController], animated: false)
    }

    @MainActor
    public func showImageDetail(photo: UnsplashPhoto, allPhotos: [UnsplashPhoto]) {
        let viewModel = DetailViewModel(
            photo: photo,
            allPhotos: allPhotos,
            favoritesUseCase: favoritesUseCase
        )
        let viewController = DetailViewController(viewModel: viewModel)

        navigationController?.pushViewController(viewController, animated: true)
    }
}
