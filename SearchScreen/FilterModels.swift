//
//  FilterModels.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 05.07.22.
//

import Foundation

struct ButtonModel {
    var title: ButtonTitle?
    
    init(title: ButtonTitle? = nil) {
        self.title = title
    }
    
    enum ButtonTitle: String {
        case size
        case country
        case language
    }
}

enum SizeFilter: String, CaseIterable {
    case large = "large"
    case medium = "medium"
    case small = "small"
}

struct CountryFilter: Codable {
    let countryCode: String
    let countryName: String
    
    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case countryName = "country_name"
    }
}

struct LanguageFilter: Codable {
    let languageCode: String
    let languageName: String
    
    enum CodingKeys: String, CodingKey {
        case languageCode = "language_code"
        case languageName = "language_name"
    }
}
