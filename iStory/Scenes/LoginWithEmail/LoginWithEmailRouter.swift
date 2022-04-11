//
//  LoginWithEmailRouter.swift
//  iStory
//
//  Created by Shyft on 4/8/22.
//

import Foundation

protocol LoginWithEmailRoutingLogic {
    func showAccessCodeScreen()
    var email: String { get set }
}

struct LoginWithEmailRouter: LoginWithEmailRoutingLogic {
    
    weak var controller: LoginWithEmailViewController?
    var email: String = ""

    func showAccessCodeScreen() {
        let accessCodeViewController = EmailAccessCodeViewController(email: email)
        controller?.navigationController?.pushViewController(accessCodeViewController, animated: true)
    }
}
