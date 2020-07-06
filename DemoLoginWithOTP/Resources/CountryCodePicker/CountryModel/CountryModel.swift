//
//  CountryModel.swift
//  CountryCode
//
//  Created by WeblineIndia  on 30/06/20.
//  Copyright © 2020 WeblineIndia . All rights reserved.
//

import Foundation

class CountryModel {
    var countryCode: String?
    var countryName: String?
    var countryShortName: String?
    var flag : String?
}

class CountryListModel {
    var country: [CountryModel]?

    init(_ data: [JSON]) {
        country = [CountryModel]()
        for dt in data {
            let ctyInfo = CountryModel()
            ctyInfo.countryName = dt["name"].stringValue
            ctyInfo.countryCode = dt["dial_code"].stringValue
            ctyInfo.countryShortName = dt["code"].stringValue
            ctyInfo.flag =  emojiFlag(countryCode: ctyInfo.countryShortName!)
            country?.append(ctyInfo)
        }
    }
    fileprivate func emojiFlag(countryCode: String) -> String {
           let base : UInt32 = 127397
           var string = ""
           let country = countryCode.uppercased().unicodeScalars
           for uS in country {
               string.unicodeScalars.append(UnicodeScalar(base + uS.value)!)
           }
           return string
       }
}
