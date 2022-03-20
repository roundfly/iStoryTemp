//
// Copyright (c) 2021 iStory.com. All rights reserved.
//

import Foundation
import KeychainServiceAPI

public struct KeychainService: KeychainServiceAPI {
    enum Key {
        static let authToken = "AuthToken"
        static let refreshToken = "RefreshToken"
    }

    private var keychain: KeychainWrapperAPI

    public init(keychain: KeychainWrapperAPI) {
        self.keychain = keychain
    }

    @discardableResult
    public func setAccessToken(_ token: String) -> Bool {
        keychain.set(token, forKey: Key.authToken)
    }

    public func getAccessToken() -> String? {
        keychain.get(Key.authToken)
    }

    @discardableResult
    public func setRefreshToken(_ token: String) -> Bool {
        keychain.set(token, forKey: Key.refreshToken)
    }

    public func getRefreshToken() -> String? {
        keychain.get(Key.refreshToken)
    }

    @discardableResult
    public func deleteAccessToken() -> Bool {
        keychain.delete(Key.authToken)
    }

    @discardableResult
    public func deleteRefreshToken() -> Bool {
        keychain.delete(Key.refreshToken)
    }

    @discardableResult
    public func clear() -> Bool {
        keychain.clear()
    }
}
