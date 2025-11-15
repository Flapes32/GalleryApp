import Foundation

public enum Config {
    public static var unsplashAccessKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "UNSPLASH_ACCESS_KEY") as? String else {
            fatalError("UNSPLASH_ACCESS_KEY not found in Config")
        }
        return key
    }
}
