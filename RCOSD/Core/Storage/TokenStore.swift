import Foundation
import Security

/// Stores the session in the iOS Keychain. Never use UserDefaults for the token.
final class TokenStore {
    static let shared = TokenStore()

    private let service = "org.rocs.osda.ios.session"
    private enum Key: String { case token, username, role }

    var token: String? { read(.token) }
    var username: String? { read(.username) }
    var role: String? { read(.role) }

    func save(token: String, username: String, role: String?) {
        write(.token, token)
        write(.username, username)
        if let role { write(.role, role) } else { delete(.role) }
    }

    func updateToken(_ token: String) {
        write(.token, token)
    }

    func clear() {
        delete(.token)
        delete(.username)
        delete(.role)
    }

    private func baseQuery(_ key: Key) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue
        ]
    }

    private func read(_ key: Key) -> String? {
        var query = baseQuery(key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func write(_ key: Key, _ value: String) {
        let data = Data(value.utf8)
        let query = baseQuery(key)
        let update: [String: Any] = [kSecValueData as String: data]
        let status = SecItemUpdate(query as CFDictionary, update as CFDictionary)
        if status == errSecItemNotFound {
            var add = query
            add[kSecValueData as String] = data
            add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            SecItemAdd(add as CFDictionary, nil)
        }
    }

    private func delete(_ key: Key) {
        SecItemDelete(baseQuery(key) as CFDictionary)
    }
}
