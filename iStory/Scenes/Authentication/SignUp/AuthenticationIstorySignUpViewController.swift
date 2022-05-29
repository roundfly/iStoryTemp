//
//  AuthenticationIstorySignUpViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import Combine
import UIKit

final class AuthenticationIstorySignUpViewController: UIViewController {

    var emailButtonPublisher: AnyPublisher<Void, Never> {
        emailSubject.eraseToAnyPublisher()
    }

    private let emailSubject = PassthroughSubject<Void, Never>()
    
    var smsButtonPublisher: AnyPublisher<Void, Never> {
        smsSubject.eraseToAnyPublisher()
    }

    private let smsSubject = PassthroughSubject<Void, Never>()

    var tryAppPublisher: AnyPublisher<Void, Never> {
        tryAppSubject.eraseToAnyPublisher()
    }

    private let tryAppSubject = PassthroughSubject<Void, Never>()

    override func loadView() {
        super.loadView()
        let viewModel = AuthenticationIstoryViewModel(title: String(localized: "splash.auth.signup.title"),
                                                      emailButtonTitle: String(localized: "auth.istory.signup.email.button.title"),
                                                      smsButtonTitle: String(localized: "auth.istory.signup.sms.button.title"),
                                                      authIntent: .signUp,
                                                      emailButtonAtion: { [emailSubject] in emailSubject.send(()) },
                                                      smsButtonAction: { [smsSubject] in smsSubject.send(()) },
                                                      tryAppAction: { [tryAppSubject] in tryAppSubject.send() })
        view = AuthenticationIstoryView(viewModel: viewModel)
    }
}
