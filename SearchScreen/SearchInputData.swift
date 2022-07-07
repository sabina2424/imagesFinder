//
//  SearchResponse.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import Foundation

struct SearchInputData {
    var image: String?
    var tbs: String? = "m"
    var tbm = "isch"
    var page: Int = 0
    var lang, country: String?
}
