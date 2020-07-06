//
//  Country.swift
//  CountryCode
//
//  Created by WeblineIndia  on 30/06/20.
//  Copyright © 2020 WeblineIndia . All rights reserved.
//

import Foundation
open class Country: NSObject {

    open var countryCode: String
    open var phoneExtension: String
    open var isMain: Bool
    open var flag : String
    public static var emptyCountry: Country { return Country(countryCode: "", phoneExtension: "", isMain: true,flag: "") }
 
    public init(countryCode: String, phoneExtension: String, isMain: Bool, flag: String) {
        self.countryCode = countryCode
        self.phoneExtension = phoneExtension
        self.isMain = isMain
        self.flag = flag
    }

    public static var currentCountry: Country {

        let localIdentifier = Locale.current.identifier //returns identifier of your telephones country/region settings

        let locale = NSLocale(localeIdentifier: localIdentifier)
        if let countryCode = locale.object(forKey: .countryCode) as? String {
            return Countries.countryFromCountryCode(countryCode.uppercased())
        }

        return Country.emptyCountry
    }

    /// Obatin the country name based on current locale
    @objc open var name: String {

        let localIdentifier = Locale.current.identifier //returns identifier of your telephones country/region settings
        let locale = NSLocale(localeIdentifier: localIdentifier)

        if let country: String = locale.displayName(forKey: .countryCode, value: countryCode.uppercased()) {
            return country

        } else {
            return "Invalid country code"
        }
    }
}

/// compare to country
///
/// - Parameters:
///   - lhs: Country
///   - rhs: Country
/// - Returns: Bool
public func ==(lhs: Country, rhs: Country) -> Bool {
    return lhs.countryCode == rhs.countryCode
}
