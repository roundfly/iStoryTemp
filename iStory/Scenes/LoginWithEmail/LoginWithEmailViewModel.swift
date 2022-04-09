//
//  LoginWithEmailViewModel.swift
//  iStory
//
//  Created by Shyft on 4/8/22.
//

import Foundation

enum LoginWithEmailViewState {
    case normal
    case error
}

struct LoginWithEmailViewModel {
    var viewState: LoginWithEmailViewState
}
