//
//  PhoneNumberService.swift
//  iStory
//
//  Created by Shyft on 4/1/22.
//

import PhoneNumberKit

final class PhoneNumberService {
    func createPhoneNumberTextField() -> PhoneNumberTextField {
        let textField = PhoneNumberTextField(frame: .zero)
        textField.withFlag = true
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        textField.withDefaultPickerUI = true
        
        return textField
    }
}
