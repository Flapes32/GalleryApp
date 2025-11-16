import XCTest
@testable import DataLayer

final class FavoritesUseCaseTests: XCTestCase {
    var sut: FavoritesUseCase!
    var repository: UserDefaultsFavoritesRepository!

    override func setUp() {
        super.setUp()
        guard let testDefaults = UserDefaults(suiteName: "test") else {
            XCTFail("Failed to create test UserDefaults")
            return
        }
        testDefaults.removePersistentDomain(forName: "test")
        repository = UserDefaultsFavoritesRepository(userDefaults: testDefaults)
        sut = FavoritesUseCase(repository: repository)
    }

    func testToggleFavorite_AddsToFavorites() async throws {
        // When
        try await sut.toggleFavorite(photoId: "test-1")

        // Then
        let isFav = await sut.isFavorite(photoId: "test-1")
        XCTAssertTrue(isFav)
    }

    func testToggleFavorite_RemovesFromFavorites() async throws {
        // Given
        try await sut.toggleFavorite(photoId: "test-1")

        // When
        try await sut.toggleFavorite(photoId: "test-1")

        // Then
        let isFav = await sut.isFavorite(photoId: "test-1")
        XCTAssertFalse(isFav)
    }
}
