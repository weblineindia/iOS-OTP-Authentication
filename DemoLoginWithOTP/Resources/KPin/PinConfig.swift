//
//  OTPVerifyConfig.swift
//
//  Created by WeblineIndia on 23/12/19.
//  Copyright © 2019 WeblineIndia. All rights reserved.
//

import Foundation
import UIKit

/// config pin
public struct PinConfig {
    public var otpLength: OTPLength?
    public var dotColor: UIColor?
    public var lineColor: UIColor?
    public var viewMain: UIView?
    public var spacing: CGFloat?
    public var isSecureTextEntry: Bool?
    public var placeHolderText: String?
    public var showPlaceHolder: Bool?
    public var enterOTPText: String?
    init(numberOfFields:OTPLength = .four, dotColor:UIColor = UIColor.black, lineColor:UIColor = .clear, viewMain:UIView = UIView(), spacing:CGFloat = 8.0, secureTextEntry: Bool = true, placeHolderText: String = "*", showPlaceHolder: Bool = true, enterOTPText : String = "Please enter OTP") {
        self.otpLength     = numberOfFields
        self.dotColor           = dotColor
        self.lineColor          = lineColor
        self.viewMain           = viewMain
        self.spacing            = spacing
        self.isSecureTextEntry    = secureTextEntry
        self.placeHolderText    = placeHolderText
        self.showPlaceHolder    = showPlaceHolder
        self.enterOTPText     = enterOTPText
    }
}
