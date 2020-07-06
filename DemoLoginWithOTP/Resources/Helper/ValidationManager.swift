//
//  ValidationManager.swift
//  DemoLoginWithOTP
//
//  Created by WeblineIndia on 23/12/19.
//  Copyright © 2019 WeblineIndia. All rights reserved.
//

import Foundation
import UIKit

class ValidationManager : NSObject{
    
    static let sharedInstance = ValidationManager()
    
    /// validate phone number only + and number
    func isValidPhoneNumber(_ number : String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"+0123456789").inverted
        let compSepByCharInSet = number.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return number == numberFiltered
    }
    
    /// - check validate and verify phone number
    func validateContryAndPhoneNumber(contryCode: String,phoneNumber: String,  isValidDetails: @escaping (_ isValidPhoneNumber: Bool,_ errorMessage: String) -> Void){
           
           let txtCountryCode = contryCode.trimmingCharacters(in: .whitespacesAndNewlines)
           if txtCountryCode.count > 0 {
               
               let txtPhone = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
               if txtPhone.count > 0 {
                   if ValidationManager.sharedInstance.isValidPhoneNumber(txtPhone){
                    isValidDetails(true, "\(txtCountryCode + txtPhone)")
                   }else{
                    isValidDetails(false, "Please enter valid PhoneNumber.")
                   }
               }else{
                isValidDetails(false, "Please enter PhoneNumber.")
               }
           }
           else {
            isValidDetails(false, "Please enter country code.")
           }
       }
}
