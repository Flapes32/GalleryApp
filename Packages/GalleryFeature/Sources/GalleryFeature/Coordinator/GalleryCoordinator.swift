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
