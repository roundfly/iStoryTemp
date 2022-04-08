//
//  MobilePhoneTextField.swift
//  iStory
//
//  Created by Shyft on 4/2/22.
//

import PhoneNumberKit
import StyleSheet

final class PhoneNumberService {
    func createPhoneNumberTextField() -> PhoneNumberTextField {
        let textField = PhoneNumberTextField(frame: .zero)
        textField.withFlag = true
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        textField.withDefaultPickerUI = true
        textField.numberPlaceholderColor = AppColor.textFieldTextColor.uiColor
        textField.countryCodePlaceholderColor = AppColor.textFieldTextColor.uiColor
        textField.textColor = AppColor.textFieldTextColor.uiColor
        
        return textField
    }
    
    func isValidPhone(number: String) -> Bool {
        return PhoneNumberKit().isValidPhoneNumber(number)
    }
}
