//
//  LoginWithSMSViewModel.swift
//  iStory
//
//  Created by Shyft on 4/2/22.
//

import Foundation
import UIKit
import PhoneNumberKit

enum LoginWithSMSViewState {
    case normal
    case error
}

enum AuthType {
    case login
    case signup
}

struct LoginWithSMSViewModel {
    let dependency: PhoneNumberService
    var viewState: LoginWithSMSViewState
    var authType: AuthType
    let normalStateErrorMessage = "Please confirm your country code and enter your phone number"
    let errorStateErrorMessage = "Error, number that you have entered is wrong! Please try again."
}
