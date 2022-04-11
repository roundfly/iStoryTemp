//
//  AuthenticationIstoryLoginViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import Combine
import UIKit

final class AuthenticationIstoryLoginViewController: UIViewController {

    var emailButtonPublisher: AnyPublisher<Void, Never> {
        emailSubject.eraseToAnyPublisher()
    }

    private let emailSubject = PassthroughSubject<Void, Never>()
    
    var smsButtonPublisher: AnyPublisher<Void, Never> {
        smsSubject.eraseToAnyPublisher()
    }

    private let smsSubject = PassthroughSubject<Void, Never>()


    override func loadView() {
        super.loadView()
        let viewModel = AuthenticationIstoryViewModel(title: String(localized: "splash.auth.login.title"),
                                                      emailButtonTitle: String(localized: "auth.istory.login.email.button.title"),
                                                      smsButtonTitle: String(localized: "auth.istory.login.sms.button.title"),
                                                      disclaimerButtonTitle: String(localized: "auth.istory.login.disclaimer.button.title"),
                                                      emailButtonAtion: { [emailSubject] in emailSubject.send(()) },
                                                      smsButtonAction: { [smsSubject] in smsSubject.send(()) } )
        view = AuthenticationIstoryView(viewModel: viewModel)
    }
}
