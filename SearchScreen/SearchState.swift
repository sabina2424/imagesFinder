//
//  SearchState.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import Foundation

enum SearchState {
    case loaded
    case isFetching(Bool)
    case error(NetworkError?)
}
