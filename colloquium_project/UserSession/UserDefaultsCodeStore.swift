import Foundation

protocol CodeStoring {
    func save(code: String)
    func load() -> String?
    func clear()
}

/// Простое хранение кода в UserDefaults,
/// не трогает другие данные и не зависит от email.
final class UserDefaultsCodeStore: CodeStoring {
    private let defaults: UserDefaults
    private let key = "student.code"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func save(code: String) {
        defaults.set(code, forKey: key)
    }

    func load() -> String? {
        defaults.string(forKey: key)
    }

    func clear() {
        defaults.removeObject(forKey: key)
    }
}
