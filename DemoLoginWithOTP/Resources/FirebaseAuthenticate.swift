//
//  FirebaseAuth.swift
//  DemoLoginWithOTP
//
//  Created by WeblineIndia on 23/12/19.
//  Copyright © 2019 WeblineIndia. All rights reserved.
//

import Foundation
import FirebaseAuth
///- FireBase authenticate with server
class FirebaseAuthenticate: NSObject {
    
    static let firSharedInstance = FirebaseAuthenticate()
    
    /// - Validate phone number and send OTP
    func validatePhoneNumber(_ number : String,completion: @escaping(String?,Error?)->()){
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (validationId, error) in
            completion(validationId,error)
        }
    }
    
    /// - Verify OTP with server
    func verifyOTPAndSigIn(verificationID id :String,otpCode code: String,completion : @escaping(AuthDataResult?,Error?)->()){
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
        Auth.auth().signIn(with: credentials) { (userData, error) in
            completion(userData,error)
        }
    }
    
    
    ///-verify phone number with firebase server and send OTP
        func sendOtpAfterValidatePhonenumber(view: UIView,phoneNowithCountryCode : String, sucesss: @escaping (_ isSendSucessOTP: Bool,_ errorMessage: String) -> Void){
           print("Entered phone number is:\(phoneNowithCountryCode)")
           HelperClass.showActivityIndicatory(uiView: view)
           FirebaseAuthenticate.firSharedInstance.validatePhoneNumber(phoneNowithCountryCode) { (verificationId, error) in
               HelperClass.hideActivityIndicator(uiView: view)
               if let error = error{
                   sucesss(false, error.localizedDescription)
               }else{
                   UserDefaults.standard.set(verificationId, forKey: "authVerificationID")
                   sucesss(true, "Sucess")
               }
           }
       }
    
       /// verify OTP with server
       func verifyOTP(otpCode: String, onSuccess: @escaping (_ userData: AuthDataResult ,_ isVarifyOTP: Bool) -> Void,onFailure: @escaping (_ error: Error ,_ isVarifyOTP: Bool) -> Void){
           if let verificationId = UserDefaults.standard.string(forKey: "authVerificationID"){
               FirebaseAuthenticate.firSharedInstance.verifyOTPAndSigIn(verificationID: verificationId, otpCode: otpCode) { (userData, error) in
                   if let error = error {
                       onFailure(error, false)
                   }else{
                       onSuccess(userData!,true)
                   }
               }
           }
       }
}
