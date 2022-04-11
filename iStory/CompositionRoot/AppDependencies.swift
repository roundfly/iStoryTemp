//
//  AppDependencies.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import Foundation
import GoogleSignInService
import PhoneNumberKit


struct AppEnvironment {
    var authentication: AuthenticationEnvironment

    static var production: AppEnvironment {
        Self(authentication: .init())
    }
}
