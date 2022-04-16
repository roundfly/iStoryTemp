//
//  KeychainWrapper.swift
//  iStory
//
//  Created by Nikola Stojanovic on 16.4.22..
//

import Foundation
import KeychainServiceAPI
import KeychainSwift

struct KeychainWrapper: KeychainWrapperAPI {
    let keychain: KeychainSwift
    let keychainAccessOptions: KeychainSwiftAccessOptions? = nil

    @discardableResult
    func set(_ value: String, forKey key: String) -> Bool {
        keychain.set(value, forKey: key, withAccess: keychainAccessOptions)
    }

    @discardableResult
    func set(_ value: Data, forKey key: String) -> Bool {
        keychain.set(value, forKey: key, withAccess: keychainAccessOptions)
    }

    @discardableResult
    func set(_ value: Bool, forKey key: String) -> Bool {
        keychain.set(value, forKey: key, withAccess: keychainAccessOptions)
    }

    func get(_ key: String) -> String? {
        keychain.get(key)
    }

    func get(_ key: String) -> Data? {
        keychain.getData(key)
    }

    func get(_ key: String) -> Bool? {
        keychain.getBool(key)
    }

    func delete(_ key: String) -> Bool {
        keychain.delete(key)
    }

    @discardableResult
    func clear() -> Bool {
        keychain.clear()
    }
}
