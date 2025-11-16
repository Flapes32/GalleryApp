import Foundation

public enum AppError: Error {
    case network(String)
    case dataStorage(String)
    case unknown(String)

    public var localizedDescription: String {
        switch self {
        case .network(let message):
            return "Network error: \(message)"
        case .dataStorage(let message):
            return "Storage error: \(message)"
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
}
