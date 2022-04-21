//
//  PhoneBookService.swift
//  iStory
//
//  Created by Bratislav Baljak on 4/15/22.
//

import Foundation
import Contacts
import UIKit

struct PhoneBookContactModel {
    let firstName: String
    let lastName: String
    let phoneNumber: String
}

final class ContactsService {
    private let store = CNContactStore()
    var whenGrantedAction: (() -> Void)?

    func getContacts() -> [PhoneBookContactModel] {
        let containers = getAllContainers()
        var contacts: [PhoneBookContactModel] = []
        
        containers.forEach { container in
            do {
                let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
                let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                let unifiedContacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                
                let formattedContacts = unifiedContacts.map { PhoneBookContactModel(firstName: $0.givenName, lastName: $0.familyName, phoneNumber: $0.phoneNumbers.first?.value.stringValue ?? "") }
                
                contacts.append(contentsOf: formattedContacts)
            } catch {
                NSLog("Failed to fetch contact, error: \(error)")
            }
        }
        
        return contacts
    }
    
    private func getAllContainers() -> [CNContainer] {
        do {
            return try store.containers(matching: nil)
        } catch {
            NSLog("Error fetching containers \(error)")
        }
        
        return []
    }
    
    func requestAccess(completion: @escaping (_ isAccepted: Bool) -> Void) {
        store.requestAccess(for: .contacts) { isAccepted, error in
            completion(isAccepted)
        }
    }
    
    func isPermissionGranted() -> Bool {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorized:
            return true
        @unknown default:
            NSLog("Unsupported case")
            return false
        }
    }
        
    func determineActionWhenAccessIsNotGranted() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined:
            requestAccess { [weak self] isAccepted in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if isAccepted {
                        self.whenGrantedAction?()
                    } else {
                        let alert = self.createAlertForOpeningAppSettings()
                        let vc = UIApplication.shared.topMostViewController()
                        vc?.present(alert, animated: true)
                    }
                }
            }
        case .restricted:
            let alert = createAlertWhenContantsAccessIsRestricted()
            let vc = UIApplication.shared.topMostViewController()
            vc?.present(alert, animated: true)
            break
        case .denied:
            let alert = createAlertForOpeningAppSettings()
            let vc = UIApplication.shared.topMostViewController()
            vc?.present(alert, animated: true)
        case .authorized:
            break
        @unknown default:
            NSLog("Unsupported case")
            break
        }
    }
    
    private func createAlertWhenContantsAccessIsRestricted() -> UIAlertController {
        UIAlertController(title: "Contacts access is restricted", message: "The user cannot change this application’s status, possibly due to active restrictions such as parental controls being in place.", preferredStyle: .alert)
    }
    
    /// After returning from system settings we should check authorizationStatus once again, if it is allowed fetch contacts
    private func createAlertForOpeningAppSettings() -> UIAlertController {
        let alert = UIAlertController(title: "Contacts access is disabled", message: "Do you want to go to the settings and enable it again?", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        
        let goButton = UIAlertAction(title: "Settings", style: .default) { action in
            alert.dismiss(animated: true) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        
        alert.addAction(cancelButton)
        alert.addAction(goButton)
        
        return alert
    }
}
