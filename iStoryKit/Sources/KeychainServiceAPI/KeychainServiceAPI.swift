import Foundation

public protocol KeychainServiceAPI {
    @discardableResult func setAccessToken(_ token: String) -> Bool
    func getAccessToken() -> String?
    @discardableResult func setRefreshToken(_ token: String) -> Bool
    func getRefreshToken() -> String?
    @discardableResult func deleteAccessToken() -> Bool
    @discardableResult func deleteRefreshToken() -> Bool
    @discardableResult func clear() -> Bool
}

public protocol KeychainWrapperAPI {
    func set(_ value: String, forKey key: String) -> Bool
    func set(_ value: Data, forKey key: String) -> Bool
    func set(_ value: Bool, forKey key: String) -> Bool
    func get(_ key: String) -> String?
    func get(_ key: String) -> Data?
    func get(_ key: String) -> Bool?
    func delete(_ key: String) -> Bool
    func clear() -> Bool
}
