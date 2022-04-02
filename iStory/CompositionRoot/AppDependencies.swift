//
//  AppDependencies.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import Foundation
import GoogleSignInService

protocol GoogleDependency {
    var googleClient: GoogleClient { get }
}

protocol AppleDependency {
    var appleClient: AppleClient { get }
}

struct AppDependencies: GoogleDependency, AppleDependency {
    var googleClient: GoogleClient { .prodution }
    var appleClient: AppleClient { .production }
}
