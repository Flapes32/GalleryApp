import Foundation

public struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]

    public init(path: String, queryItems: [URLQueryItem] = []) {
        self.path = path
        self.queryItems = queryItems
    }

    public var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
