//
//  UserDefaultsClient.swift
//  
//
//  Created by Nikola Stojanovic on 20.5.22..
//

import Foundation

public struct UserDefaultsClient {
    public var boolForKey: (String) -> Bool
    public var dataForKey: (String) -> Data?
    public var doubleForKey: (String) -> Double
    public var integerForKey: (String) -> Int
    public var setBool: (Bool, String) -> Void
    public var setData: (Data?, String) -> Void
    public var setDouble: (Double, String) -> Void
    public var setInteger: (Int, String) -> Void

    public var hasShownLoggedInUserHome: Bool {
        self.boolForKey(hasShownLoggedInUserHomeKey)
    }

    public func setHasShownFirstLaunchOnboarding(_ bool: Bool) -> Void {
        self.setBool(bool, hasShownLoggedInUserHomeKey)
    }

    public static var production: UserDefaultsClient {
        Self(boolForKey: UserDefaults.standard.bool(forKey:),
             dataForKey: UserDefaults.standard.data(forKey:),
             doubleForKey: UserDefaults.standard.double(forKey:),
             integerForKey: UserDefaults.standard.integer(forKey:),
             setBool: UserDefaults.standard.set(_:forKey:),
             setData: UserDefaults.standard.set(_:forKey:),
             setDouble: UserDefaults.standard.set(_:forKey:),
             setInteger: UserDefaults.standard.set(_:forKey:))
    }
}

var hasShownLoggedInUserHomeKey: String {
    #function
}
