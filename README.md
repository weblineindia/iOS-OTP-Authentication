# iOS OTP Authentication

This demo is of iOS based OTP Authentication, used to verify your mobile number with OTP (One Time Password).

## Table of contents
- [iOS Support](#iOS-support)
- [Demo](#demo)
- [Features](#features)
- [Getting started](#getting-started)
- [Usage](#usage)
- [Methods](#methods)
- [Directive options](#directive-options)
- [Want to Contribute?](#want-to-contribute)
- [Need Help / Support?](#need-help)
- [Collection of Components](#collection-of-Components)
- [Changelog](#changelog)
- [License](#license)
- [Keywords](#Keywords)


## iOS Support

Version - iOS 13.x or later

We have tested our program in above versions, however you can use it in other versions as well


## Demo
[![](OTP_Authentication.png)](https://github.com/weblineindia/iOS-OTP-Authentication/blob/master/OTP_Authentication.png)

------

## Features
* Select country with flag & country code
* Verify mobile number with OTP all over the world


## Getting started
Download this sample project and import swift utility resource files in your project. 

## Usage
Process setup is described below to integrate in sample project.

Configure your required property of  countriesPickerVcObj
Also set delegate and implement method for call back selected country details
e.g. 

    extension ViewController: CountriesViewControllerDelegate {   
    func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountry country: Country) {
        //Return last selected country details
        }}

### Create  CountryModel object for store last selected country details
    var selectedCountry:CountryModel?


## Methods

### PinView Class For OTP(One Time Password)
- Setup pinview and config validation you want to setup
below field config 
1. Create PinView Outlet of StackView
2. Access config form Pinview outlet properties
setup below validation base on your requirement
---------------------------------------------------------------------------------------------------------
        var config:PinConfig!     = PinConfig()
        // Length of OTP
        config.otpLength          = .six
        // Secure text mask color
        config.dotColor           = .black
        config.lineColor          = #colorLiteral(red: 0.8265652657, green: 0.8502194881, blue: 0.9000532627, alpha: 1)
        //Space beetween two text field
        config.spacing            = 30
        //set secure text
        config.isSecureTextEntry  = true
        //show place hodder
        config.showPlaceHolder    = true
---------------------------------------------------------------------------------------------------------

### Setup text field delegate
 like Enter only specify values in textfield
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        ///- For Phone number validation
        if textField == txtPhoneNumberField {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        else{
            return true
        }
    }
    
### setup OTP view
    - setUpOTPView: this method provide setup of OTP text field like below


### validateOtpAndVerifyViaServer
validate number with server use of below method
- enter OTP 
- callback response
    
      self.countriesPickerVcObj.verifyOTP(otpCode: "123456", onSuccess:(authDataResult,bool) , onFailure:(error,isError)


 ### send OTP to given details
 - enter country code
 - enter phone numner
 - call back validate details information
 
       self.countriesPickerVcObj.validateContryAndPhoneNumber(contryCode: "+1", phoneNumber: "9XXXXXXXXX", isValidDetails:(isValid,strMsg)


### validatePhoneNumber
- Param 
  - number
- callBack
  - return validationId & error details
this method validate phone number and send OTP


### verifyOTPAndSigIn
Param
 - enter OTP
callback
 - AuthDataResult object & error details

### sendOtpAfterValidatePhonenumber
Param
 - view: for show indicator
 - phoneNowithCountryCode : for Example "+919XXXXXXXX"
 sucesss
  - return isSendSucessOTP status of send otp or not 
  - return errorMessage show error
call this method after check text field details


### verifyOTP
 Param
  - otpCoed
OnSuccess
 - AuthDataResult : get user data
 - isVarifyOTP : check otp verify or not
onFailure
 - error : display error
 - isVarifyOTP : check otp verify or not

------

## Directive options

### Firebase project setup steps
Create  Project setup in firebase console using below URL
https://console.firebase.google.com/
 Please Enable Phone Number sign-in for your Firebase project in console    
https://firebase.google.com/docs/auth/ios/phone-auth

Download GoogleService-Info.Plist file and add into project 
install firebase pod and run project 


### Pod installation process
The `OTPAuthentication` demo use in you app then same option as the `<OTPAuthentication>`
install firebase pod
- pod 'Firebase/Analytics'
- pod 'Firebase/Auth'
   
show country picker use of below method help of CountriesViewController class object
- CountriesViewController.show(countriesViewController: self.countriesPickerVcObj, toVar: self)
 
- select country and Phone number

- Press send button to validate entered details and send OTP help of below mehods

      FirebaseAuthenticate.firSharedInstance.sendOtpAfterValidatePhonenumber

- Verify OTP with below method

      FirebaseAuthenticate.firSharedInstance.verifyOTP
      
------

## Want to Contribute?

- Created something awesome, made this code better, added some functionality, or whatever (this is the hardest part).
- [Fork it](http://help.github.com/forking/).
- Create new branch to contribute your changes.
- Commit all your changes to your branch.
- Submit a [pull request](http://help.github.com/pull-requests/).

------

## Need Help? 
We also provide a free, basic support for all users who want to use this OTP verification demo in project. In case you want to customize this OTP demo input to suit your development needs, then feel free to contact our [iOS
developers](https://www.weblineindia.com/hire-ios-app-developers.html).

 ------
 
 ## Collection of Components
 We have built many other components and free resources for software development in various programming languages. Kindly click here to view our [Free Resources for Software Development.](https://www.weblineindia.com/software-development-resources.html)
 
------

## Changelog
Detailed changes for each release are documented in [CHANGELOG.md](./CHANGELOG.md).

## License

[MIT](LICENSE)

[mit]: https://github.com/weblineindia/iOS-OTP-Authentication/blob/master/LICENSE

## Keywords
OTP, Firebase Authentication, One Time Password, OTP For iOS, OTP Authentication, Mobile Number Verficiation,
OTP Verification, Firebase OTP Authentication, weblineindia
