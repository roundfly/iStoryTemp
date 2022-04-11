//
//  AuthenticationAction.swift
//  iStory
//
//  Created by Nikola Stojanovic on 9.4.22..
//

typealias Credentials = (email: String, password: String)

enum AuthenticationAction {
    case signUp(user: Credentials)
    case logIn(user: Credentials)
    case loggedIn(user: User)
    case authFailure(reason: String)
}
