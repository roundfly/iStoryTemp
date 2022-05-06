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
    var store: AuthenticationStore

    func showAccessCodeScreen() {
        let viewModel = AccessCodeViewModel(accessCodeSource: .sms, store: store)
        let accessCodeViewController = AccessCodeViewController(viewModel: viewModel)
        controller?.navigationController?.pushViewController(accessCodeViewController, animated: true)
    }
}
