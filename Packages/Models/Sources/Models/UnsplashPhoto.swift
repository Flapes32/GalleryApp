import Foundation

public struct UnsplashPhoto: Codable, Identifiable {
    public let id: String
    public let createdAt: String?
    public let width: Int
    public let height: Int
    public let color: String?
    public let description: String?
    public let altDescription: String?
    public let urls: PhotoURLs
    public let user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case color
        case description
        case altDescription = "alt_description"
        case urls
        case user
    }

    public init(
        id: String,
        createdAt: String?,
        width: Int,
        height: Int,
        color: String?,
        description: String?,
        altDescription: String?,
        urls: PhotoURLs,
        user: User?
    ) {
        self.id = id
        self.createdAt = createdAt
        self.width = width
        self.height = height
        self.color = color
        self.description = description
        self.altDescription = altDescription
        self.urls = urls
        self.user = user
    }
}

public struct PhotoURLs: Codable {
    public let raw: String
    public let full: String
    public let regular: String
    public let small: String
    public let thumb: String

    public init(raw: String, full: String, regular: String, small: String, thumb: String) {
        self.raw = raw
        self.full = full
        self.regular = regular
        self.small = small
        self.thumb = thumb
    }
}

public struct User: Codable {
    public let id: String
    public let username: String
    public let name: String

    public init(id: String, username: String, name: String) {
        self.id = id
        self.username = username
        self.name = name
    }
}
