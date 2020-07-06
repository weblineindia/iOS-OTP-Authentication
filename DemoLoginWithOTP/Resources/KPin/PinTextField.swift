//
//  OTPTextField.swift
//
//  Created by WeblineIndia on 23/12/19.
//  Copyright © 2019 WeblineIndia. All rights reserved.
//

import UIKit

protocol OTPTextFieldDelegate {
    func OTPTextFieldDidPressBackspace(textfield: PinTextField)   
}

/// Text Delegte for backspace
class PinTextField: UITextField {

    var delegateOTP:OTPTextFieldDelegate!
    override func deleteBackward() {
        super.deleteBackward()
        
        if delegateOTP != nil {
            delegateOTP.OTPTextFieldDidPressBackspace(textfield: self)
        }
    }
}
