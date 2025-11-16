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

    func testRefreshPhotos_ResetsPhotos() async {
        // Given
        mockUnsplashService.mockPhotos = [createMockPhoto()]
        await sut.loadPhotos()
        XCTAssertEqual(sut.photos.count, 1)

        // When
        await sut.refreshPhotos()

        // Then
        XCTAssertEqual(sut.photos.count, 1)
        XCTAssertFalse(sut.isLoading)
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

// MARK: - Mock Classes

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
