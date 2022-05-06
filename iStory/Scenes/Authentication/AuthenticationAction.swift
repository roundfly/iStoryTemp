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
    case submitBirthday(date: Date)
    case submittedBirthday(date: Date)
    case submitEmailAccessCode(accessCode: String)
    case submittedAccessCode
    case forgotPassword(email: String)
    case forgotPasswordSubmitted
    case submitForgotPasswordAccessCode(accessCode: String)
    case forgotPasswordAcessCodeSubmitted(email: String, token: String)
    case loggedIn(user: User)
    case signedIn(user: User, token: AccessToken?)
    case loggedInWithGoogle(googleUser: GoogleUser)
    case loggedInWithIstoryFromGoogle(User, AccessToken)
    case loggedInWithAmazon(token: String)
    case authFailure(reason: String)
    case accessCodeFailure(reason: String)
    case forgotPasswordFailure(reason: String)
    case googleSignIn(presentingViewController: UIViewController)
    case amazonSignIn
}
