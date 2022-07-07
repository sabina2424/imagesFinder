//
//  DetailsViewModel.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import Foundation

class DetailsViewModel {
    var photos: [ImagesResult]
    var indexPath: Int
    
    init(photos: [ImagesResult], indexPath: Int) {
        self.photos = photos
        self.indexPath = indexPath
    }
}
