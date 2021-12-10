//
//  ViewController.swift
//  DemoLoginWithOTP
//
//  Created by WeblineIndia on 23/12/19.
//  Copyright © 2019 WeblineIndia. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var imgview: UIImageView!
    
    @IBOutlet weak var lblFlag: UITextField!
    @IBOutlet weak var viewLogin: UIView!
    
    @IBOutlet weak var viewNumber: UIView!
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var pinView : PinView!
    @IBOutlet weak var btnSendOTP : UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!

    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var lblCountryCode: UILabel!
    var countriesPickerVcObj = CountriesViewController()
    var selectedCountry:CountryModel?
    
    //MARK: View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBord))
        view.addGestureRecognizer(tap)
        
        viewLogin.layer.cornerRadius = 10
        viewLogin.clipsToBounds  = true
        btnSendOTP.layer.cornerRadius = btnSendOTP.frame.size.height / 2
        btnSendOTP.clipsToBounds = true
        
        viewNumber.layer.cornerRadius =  viewNumber.frame.size.height / 2
        viewNumber.clipsToBounds  = true
        viewNumber.layer.borderColor = UIColor.blue.cgColor
        viewNumber.layer.borderWidth = 0.2
        
        setupCountryPicker()
        setUpOTPView()
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        viewLogin.layer.masksToBounds = false
        viewLogin.layer.shadowColor = UIColor.gray.cgColor
        viewLogin.layer.shadowOffset = CGSize(width: 0, height: 5)
        viewLogin.layer.shadowOpacity = 0.35
        viewLogin.layer.shadowPath = UIBezierPath(roundedRect: viewLogin.bounds, cornerRadius: viewLogin.layer.cornerRadius).cgPath
    }
    
    @objc func dismissKeyBord(){
        self.view.endEditing(true)
    }
     ///- setup for country code list
    func setupCountryPicker(){
        self.countriesPickerVcObj = CountriesViewController()
        self.countriesPickerVcObj.delegate = self
        if let info = countriesPickerVcObj.getCountryAndName() {
            selectedCountry = info
            self.lblFlag.text = info.flag!
            self.lblCountryCode.text = info.countryCode!
        }
    }
    
     ///- Config OTP view
    func setUpOTPView(){
       var config:PinConfig!     = PinConfig()
         config.otpLength          = .six
         config.dotColor           = .black
         config.lineColor          = #colorLiteral(red: 0.8265652657, green: 0.8502194881, blue: 0.9000532627, alpha: 1)
         config.spacing            = 30
         config.isSecureTextEntry  = true
         config.showPlaceHolder    = true
        
        pinView.config = config
        pinView.setUpView()
        //Delegate for validate text
        txtPhoneNumber.delegate = self
        txtPhoneNumber.becomeFirstResponder()
      
    }
   
    
    ///- Enter only specify code in text fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        ///- For Phone number validation
        if textField == txtPhoneNumber {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        else{
            return true
        }
    }
   
    ///-  submit OTP to server
    func validateOtpAndVerifyViaServer(){
        var otpCode:String = ""
        do {
            otpCode = try self.pinView.getOTP()
            print("Enter OTP is:\(otpCode)")
            HelperClass.showActivityIndicatory(uiView: self.view)
            FirebaseAuthenticate.firSharedInstance.verifyOTP(otpCode: otpCode, onSuccess: { (useraData, isVerified) in
               
                HelperClass.hideActivityIndicator(uiView: self.view)
                self.showAlertMessage("OTP Verified Successfully")

                self.lblTitle.text = "Login"
                self.lblSubTitle.text = "Enter your mobile number to receive a verification code"
                self.btnSendOTP.setTitle("Send OTP", for: .normal)

                self.viewOtp.isHidden = true
                self.viewNumber.isHidden = false

                self.txtPhoneNumber.text = ""
                self.imgview.image = UIImage.init(named: "registration")
                
            }) { (error, isvalid) in
                HelperClass.hideActivityIndicator(uiView: self.view)
                self.showAlertMessage(error.localizedDescription)
            }
        } catch OTPError.inCompleteOTPEntry {
            self.showAlertMessage(OTPError.inCompleteOTPEntry.localizedDescription)
            print("Incomplete OTP Entry valid error")
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Action Methods
     ///- verify number and Send OTP request
    @IBAction func btnSendOTP(_ sender : UIButton){
        self.dismissKeyBord()
        if btnSendOTP.titleLabel?.text == "Send OTP" {
            ValidationManager.sharedInstance.validateContryAndPhoneNumber(contryCode: selectedCountry?.countryCode! ?? "", phoneNumber: txtPhoneNumber.text!) { (isValidDetails, message) in
                if isValidDetails {
                    //Send OTP to given number
                    FirebaseAuthenticate.firSharedInstance.sendOtpAfterValidatePhonenumber(view: self.view, phoneNowithCountryCode: message) { (isSucess, message) in
                        if isSucess {
                          
                            self.viewOtp.isHidden = false
                            self.viewNumber.isHidden = true
                            self.btnSendOTP.setTitle("Verify", for: .normal)
                            self.lblTitle.text = "Verification"
                            self.imgview.image = UIImage.init(named: "verification")
                            self.lblSubTitle.text = "Enter A 6 digit number that was sent to " + "\(self.selectedCountry?.countryCode ?? "+91")" + "\(self.txtPhoneNumber.text ?? "")"
                            self.pinView.textFields[0].becomeFirstResponder()
                        }else {
                            self.showAlertMessage(message)
                        }
                    }
                } else{
                    self.showAlertMessage(message)
                }
            }
        }else{
            validateOtpAndVerifyViaServer()
        }
    }
    
    /// - Resend OTP
    @IBAction func btnResend(_ sender : UIButton){
        self.dismissKeyBord()
        pinView.clearOTP()
        ValidationManager.sharedInstance.validateContryAndPhoneNumber(contryCode: selectedCountry?.countryCode! ?? "", phoneNumber: txtPhoneNumber.text!) { (istrue, message) in
            FirebaseAuthenticate.firSharedInstance.sendOtpAfterValidatePhonenumber(view: self.view, phoneNowithCountryCode: message) { (isResend, message) in
                if isResend  {
                    //show alert resend otp sucess
                    }else {
                    //show alert resend otp faild
                }
            }
        }
    }
    
    @IBAction func btnCancelOTP(_ sender: UIButton) {
        self.btnSendOTP.setTitle("Send OTP", for: .normal)
        self.txtPhoneNumber.text = ""
        self.lblSubTitle.text = "Please enter your mobile no with country code to receive OTP."
        self.txtPhoneNumber.becomeFirstResponder()
    }
    @IBAction func btnCountryPicker(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            CountriesViewController.show(countriesViewController: self.countriesPickerVcObj, toVar: self)
        }
    }
    ///- show alert message
       func showAlertMessage(_ message : String){
           let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
           let ok = UIAlertAction(title: "OK", style: .default) { (action) in
               self.pinView.clearOTP()
           }
           alert.addAction(ok)
           self.present(alert, animated: true, completion: nil)
       }
}

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
///- open country picker
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == self.txtCountryField {
//            DispatchQueue.main.async {
//                CountriesViewController.show(countriesViewController: self.countriesPickerVcObj, toVar: self)
//            }
//            return false
//        }
//        return true
//    }
}

///Country code picker delegate
extension ViewController: CountriesViewControllerDelegate {
   
    func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountry country: Country) {
        if let info = self.countriesPickerVcObj.getCountryAndName(country.countryCode) {
            selectedCountry = info
            lblCountryCode.text = info.countryCode!
            lblFlag.text = info.flag
        }
    }
}
