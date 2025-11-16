import Foundation

public protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

public enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case unknown
}
