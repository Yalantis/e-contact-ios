import Foundation
import KeychainAccess

class CredentialStorage {

    private let keychain: Keychain

    private var isAppFirstLaunch: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("isFirstLaunch") as? Bool ?? true
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "isFirstLaunch")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    // MARK: - Init

    init(bundleIdentifier: String) {
        keychain = Keychain(service: bundleIdentifier).accessibility(.AfterFirstUnlock)
    }

    static func defaultCredentialStorage() -> CredentialStorage {
        return CredentialStorage(bundleIdentifier: NSBundle.mainBundle().bundleIdentifier!)
    }

    // MARK: - Access

    func cleanKeychainIfNeeded() {
        if isAppFirstLaunch {
            removeCredentialForKey(Key.UserSession)
            isAppFirstLaunch = false
        }
    }

    func credentialsForKey(key: String) -> Credentials? {
            guard let result = try? keychain.getData(key),
                data = result,
                value = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Credentials else {
                return nil
            }

            return value
    }

    func setCredentials(credentials: Credentials, forKey key: String) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(credentials)

        try? keychain.set(data, key: key)
    }

    func removeCredentialForKey(key: String) {
        let _ = try? keychain.remove(key)
    }

    subscript(key: String) -> Credentials? {
        get {
            return credentialsForKey(key)
        }
        set {
            if let value = newValue {
                setCredentials(value, forKey: key)
            } else {
                removeCredentialForKey(key)
            }
        }
    }

}

extension CredentialStorage {

    struct Key {

        static let UserSession = "userSession"
    }

    var userSession: Credentials? {
        get {
            return self[Key.UserSession]
        }

        set {
            self[Key.UserSession] = newValue
        }
    }

}
