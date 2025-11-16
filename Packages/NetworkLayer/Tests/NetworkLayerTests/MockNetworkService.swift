import Foundation
@testable import NetworkLayer
import Models

final class MockNetworkService: NetworkService {
    var mockData: Any?
    var shouldThrowError = false

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        if shouldThrowError {
            throw NetworkError.unknown
        }

        guard let data = mockData as? T else {
            throw NetworkError.decodingError
        }

        return data
    }
}
