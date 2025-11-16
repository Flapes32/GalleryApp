import XCTest
@testable import NetworkLayer
import Models

final class UnsplashServiceTests: XCTestCase {
    var sut: UnsplashService!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = UnsplashService(networkService: mockNetworkService)
    }

    func testFetchPhotos_Success() async throws {
        // Given
        let mockPhotos = [
            UnsplashPhoto(
                id: "1",
                createdAt: nil,
                width: 1000,
                height: 1000,
                color: "#000",
                description: "Test",
                altDescription: "Test Alt",
                urls: PhotoURLs(raw: "", full: "", regular: "", small: "", thumb: ""),
                user: nil
            )
        ]
        mockNetworkService.mockData = mockPhotos

        // When
        let result = try await sut.fetchPhotos(page: 1, perPage: 30)

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
    }
}
