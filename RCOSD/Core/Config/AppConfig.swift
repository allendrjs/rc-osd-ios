import Foundation

enum AppConfig {
    /// Debug: http://localhost:8080 (the iOS Simulator shares the Mac's network).
    /// Release: https://rc-osd.tech. Set per configuration in project.yml.
    static let apiBaseURL: URL = {
        if let value = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
           let url = URL(string: value), !value.isEmpty, value != "$(API_BASE_URL)" {
            return url
        }
        #if DEBUG
        return URL(string: "http://localhost:8080")!
        #else
        return URL(string: "https://rc-osd.tech")!
        #endif
    }()

    static let connectTimeout: TimeInterval = 15
    static let requestTimeout: TimeInterval = 90
}
