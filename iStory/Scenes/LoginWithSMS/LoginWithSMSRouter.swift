//
//  LoginWithSMSRouter.swift
//  iStory
//
//  Created by Shyft on 4/8/22.
//

protocol LoginWithSMSRoutingLogic {
    func showAccessCodeScreen()
    var number: String { get set }
}

struct LoginWithSMSRouter: LoginWithSMSRoutingLogic {
    
    weak var controller: LoginWithSMSViewController?
    var number: String = ""

    func showAccessCodeScreen() {
        let accessCodeViewController = SMSAccessCodeViewController(receiver: number)
        controller?.navigationController?.pushViewController(accessCodeViewController, animated: true)
    }
}
