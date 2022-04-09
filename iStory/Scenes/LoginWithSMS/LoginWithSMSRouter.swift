//
//  LoginWithSMSRouter.swift
//  iStory
//
//  Created by Shyft on 4/8/22.
//

import Foundation

protocol LoginWithSMSRoutingLogic {
    func showAccessCodeScreen()
    var number: String { get set }
}

struct LoginWithSMSRouter: LoginWithSMSRoutingLogic {
    
    weak var controller: LoginWithSMSViewController?
    var number: String = ""

    func showAccessCodeScreen() {
        let accessCodeViewController = SMSAccessCodeViewController(number: number)
        controller?.navigationController?.pushViewController(accessCodeViewController, animated: true)
    }
}
