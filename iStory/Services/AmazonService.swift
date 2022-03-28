//
//  AmazonService.swift
//  iStory
//
//  Created by Shyft on 3/28/22.
//

import Foundation
import LoginWithAmazon

final class AmazonService {
    func openAuthorizeRequest() {
        let request = AMZNAuthorizeRequest()
        request.scopes = [AMZNProfileScope.profile(), AMZNProfileScope.postalCode()]
        
        AMZNAuthorizationManager.shared().authorize(request) { result, isSuccess, error in
            print("RESULT \(result?.token)")
            print("Error \(error)")
        }
    }
}
