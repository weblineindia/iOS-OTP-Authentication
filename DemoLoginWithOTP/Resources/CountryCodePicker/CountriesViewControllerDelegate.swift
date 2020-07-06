//
//  CountriesViewControllerDelegate.swift
//  CountryCode
//
//  Created by WeblineIndia  on 30/06/20.
//  Copyright © 2020 WeblineIndia . All rights reserved.
//

import Foundation
/// Delegate
@objc public protocol CountriesViewControllerDelegate {
    
    /// Comunicate delegates that controller has been closed
    ///
    /// - Parameter countriesViewController: countriesViewController
    @objc optional func countriesViewControllerDidCancel(_ countriesViewController: CountriesViewController)
    
    /// Comunicate delegates that a country has been selected
    ///
    /// - Parameters:
    ///   - countriesViewController: countriesViewController
    ///   - country: a country selected
   func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountry country: Country)
    
    /// Comunicate delegates that a country has been unselected
    ///
    /// - Parameters:
    ///   - countriesViewController: countriesViewController
    ///   - country: a country unselected
    @objc optional  func countriesViewController(_ countriesViewController: CountriesViewController, didUnselectCountry country: Country)
    
    /// Comunicate delegates that some countries has been selected
    ///
    /// - Parameters:
    ///   - countriesViewController: countriesViewController
    ///   - countries: [Country]
    @objc optional func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountries countries: [Country])
    
}
