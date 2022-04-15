//
//  AuthenticationAction.swift
//  iStory
//
//  Created by Nikola Stojanovic on 9.4.22..
//

import UIKit
import GoogleSignInService

typealias Credentials = (email: String, password: String)

enum AuthenticationAction {
    case signUp(user: Credentials)
    case logIn(user: Credentials)
    case loggedIn(user: User)
    case loggedInWithGoogle(googleUser: GoogleUser)
    case loggedInWithAmazon(token: String)
    case authFailure(reason: String)
    case googleSignIn(presentingViewController: UIViewController)
    case amazonSignIn
}
