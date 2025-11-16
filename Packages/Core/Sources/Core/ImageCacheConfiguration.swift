import Foundation
import Kingfisher

public enum ImageCacheConfiguration {
    public static func configure() {
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024 // 100 MB
        cache.diskStorage.config.sizeLimit = 200 * 1024 * 1024 // 200 MB
    }
}

