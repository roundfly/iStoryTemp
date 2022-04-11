//
//  AppDependencies.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import Foundation
import GoogleSignInService
import PhoneNumberKit

protocol GoogleDependency {
    var googleClient: GoogleClient { get }
}

protocol AppleDependency {
    var appleClient: AppleClient { get }
}

protocol PhoneNumberDependency {
    var phoneNumberKit: PhoneNumberService { get }
}

protocol AmazonDependency {
    var amazonService: AmazonService { get }
}

struct AppDependencies: GoogleDependency, AppleDependency, PhoneNumberDependency, AmazonDependency {    
    var phoneNumberKit: PhoneNumberService { .init() }
    var googleClient: GoogleClient { .prodution }
    var appleClient: AppleClient { .production }
    var amazonService: AmazonService { .init() }
}
