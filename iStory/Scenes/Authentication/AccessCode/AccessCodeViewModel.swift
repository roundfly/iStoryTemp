//
//  AccessCodeViewModel.swift
//  iStory
//
//  Created by Nikola Stojanovic on 29.4.22..
//

import Foundation
import Combine
import UIKit

final class AccessCodeViewModel {
    enum AccessCodeSource {
        case email
        case sms
    }

    private var accessCode: String = ""
    private (set) var store: AuthenticationStore
    private var accessCodeSource: AccessCodeSource

    var receiver: String {
        accessCodeSource == .email ? store.state.currentUser?.email ?? "" : store.state.currentUser?.number ?? ""
    }

    init(accessCodeSource: AccessCodeSource, store: AuthenticationStore) {
        self.accessCodeSource = accessCodeSource
        self.store = store
    }

    func consumeAccessCode(from textFields: [UITextField]) {
        accessCode = ""
        for textField in textFields {
            accessCode += textField.text ?? ""
        }
    }

    func submitCode() {
        guard accessCode.count == 6 else {
            store.dispatch(.accessCodeFailure(reason: "Please enter a 6 character access code."))
            return
        }
        store.dispatch(.submitEmailAccessCode(accessCode: accessCode))
    }
}
