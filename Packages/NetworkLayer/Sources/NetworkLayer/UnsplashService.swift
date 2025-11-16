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
