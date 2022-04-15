//
//  AuthenticationState.swift
//  iStory
//
//  Created by Nikola Stojanovic on 9.4.22..
//

import Foundation

struct User: Identifiable, Equatable {
    let id = UUID()
}

struct AuthenticationState: Equatable {
    var currentUser: User?
    var authFailure: String?
}
