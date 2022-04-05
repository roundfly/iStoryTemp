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

struct LoginWithSMSViewModel {
    let dependency: PhoneNumberService
    var viewState: LoginWithSMSViewState
    let normalStateErrorMessage = "Please confirm your country code and enter your phone number"
    let errorStateErrorMessage = "Error, number that you have entered is wrong! Please try again."
}
