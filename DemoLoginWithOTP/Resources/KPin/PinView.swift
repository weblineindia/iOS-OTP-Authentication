//
//  OTPVerifyView.swift
//
//  Created by WeblineIndia on 23/12/19.
//  Copyright © 2019 WeblineIndia. All rights reserved.
//

import UIKit

/// OTP error (empty or Incomplete
public enum OTPError: Error {
    case inCompleteOTPEntry
    
    public var localizedDescription: String {
        switch self {
        case .inCompleteOTPEntry:  return "Incomplete OTP Entry"
        }
    }
}

/// set OTP length
public enum OTPLength {
    case four
    case six
    case custom(Int)
    var value: Int {
        switch self {
        case .four: return 4
        case .six: return 6
        case .custom(let num): return num
        }
    }
    
    var lineLength: Int? {
        switch self {
        case .four: return 40
        case .six: return 30
        case .custom: return nil
        }
    }
}

/// setup pin UI view
class PinView: UIStackView, UITextFieldDelegate, OTPTextFieldDelegate {
    
    lazy public var config:PinConfig! = PinConfig()
    var textFields = [UITextField]()
    var lblErrorText = UILabel()
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(config:PinConfig = PinConfig()) {
        self.init()
        self.config         = config
        self.spacing        = config.spacing!
        self.axis           = .horizontal
        self.alignment      = .fill
        self.distribution   = .fillProportionally
    }
    
    /// setupview call after create object of Pinview
    public func setUpView() {
        
        for _ in 0..<config.otpLength!.value {
            let view = UIView()
            view.backgroundColor = .clear
            addArrangedSubview(view)
        }
        
        self.layoutIfNeeded()
        for i in stride(from: 0, to: config.otpLength!.value, by:1) {
            let view = self.arrangedSubviews[i]
            let frameSize:CGSize = self.arrangedSubviews[i].frame.size
            let textField:PinTextField      = PinTextField()
            textField.delegateOTP           = self
            textField.tag                   = i+100
            textField.frame                 = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height - 1)
            textField.delegate              = self
            textField.isSecureTextEntry     = config.isSecureTextEntry!
            textField.placeholder           = config.showPlaceHolder! ? config.placeHolderText : ""
            textField.backgroundColor       = .white
            textField.textAlignment         = .center
            textField.borderStyle           = .none
            textField.keyboardType          = .numberPad
            textField.textColor             = config.dotColor
            textField.font                  = UIFont.boldSystemFont(ofSize: 25.0)
            textField.tintColor             = .clear
            
            view.addSubview(textField)
            let viewLine                = UIView()
            viewLine.backgroundColor    = config.lineColor

            let viewLineFrame: CGRect
            if let lineWidth = config.otpLength!.lineLength {
                viewLineFrame           = CGRect(x: CGFloat(view.frame.width / 2) - CGFloat(lineWidth / 2), y: frameSize.height - 1, width: CGFloat(lineWidth), height: 1)
            } else {
                viewLineFrame           = CGRect(x: 0, y: frameSize.height - 1, width: frameSize.width, height: 1)
            }
            viewLine.frame = viewLineFrame
            view.addSubview(viewLine)
            self.textFields.append(textField)
        }
        let frameSize:CGSize = self.arrangedSubviews[0].frame.size

        lblErrorText.frame = CGRect(x: 10 - self.frame.origin.x, y: frameSize.height + 5, width: self.frame.width + (self.frame.origin.x * 2) - 10, height: 50)
        lblErrorText.numberOfLines = 0
        lblErrorText.text = config.enterOTPText
        lblErrorText.textAlignment = .center        
        self.addSubview(lblErrorText)
    }
    
    /// text field change move responder
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0 {
            if textField.text?.count == 0 {
                if let previousTextField = self.viewWithTag(textField.tag-1) {
                    previousTextField.becomeFirstResponder()
                }
            }
        } else {
            if let currentTextField = self.viewWithTag(textField.tag+1) {
                currentTextField.becomeFirstResponder()
            } else {
                if !textField.text!.isEmpty {
                    return false
                }
            }
        }
        textField.text = string
        lblErrorText.text = ""
        if textField.tag == 105 && string.count > 0 {
            textField.resignFirstResponder()
        }
        return false
    }
    
    /// Get OTP form text
    func getOTP() throws -> String {
        var otpCode:String = ""
        for textField in textFields {
            if textField.text == "" {
                throw OTPError.inCompleteOTPEntry
            }
            otpCode += textField.text!
        }
        return otpCode
    }
    
    /// Delagate call when user press backspace
    func OTPTextFieldDidPressBackspace(textfield: PinTextField) {
        if let previousTextField: PinTextField = self.viewWithTag(textfield.tag-1) as? PinTextField {
            previousTextField.text = ""
            previousTextField.becomeFirstResponder()
        } else{
            lblErrorText.text = config.enterOTPText
        }
        if textfield.tag == 101{
            lblErrorText.text = config.enterOTPText
        }
    }
    
    /// Clear OTP text
    func clearOTP(){
        for textField in textFields{
            textField.text = ""
        }
        lblErrorText.text = config.enterOTPText
    }
}
