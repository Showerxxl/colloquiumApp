import Foundation

protocol SessionStoring {
    func save(_ session: UserSession)
    func load() -> UserSession?
    func clear()
}

final class UserDefaultsSessionStore: SessionStoring {
    private let key = "user.session.v1"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func save(_ session: UserSession) {
        do {
            let data = try JSONEncoder().encode(session)
            defaults.set(data, forKey: key)
        } catch {
            print("❌ Failed to encode session: \(error)")
        }
    }

    func load() -> UserSession? {
        guard let data = defaults.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(UserSession.self, from: data)
        } catch {
            print("❌ Failed to decode session: \(error)")
            return nil
        }
    }

    func clear() {
        defaults.removeObject(forKey: key)
    }
}
