//
//  AuthenticationState.swift
//  iStory
//
//  Created by Nikola Stojanovic on 9.4.22..
//

import Foundation

struct User: Identifiable, Equatable {
    let id = UUID()
    var email: String?
    var number: String?
    var password: String?
    var didSubmitValidAccessCodeInSession: Bool = false
}

struct AuthenticationState: Equatable {
    var currentUser: User?
    var accessToken: AccessToken?
    var userBirthday: Date?
    var authFailure: String?
    var accessCodeFailure: String?
    var showForgotPasswordAccessCodeFlow = false
    var didSignIn = false
}
