//
//  UIImageView+Ext.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import UIKit

let imageCache = NSCache< NSString, UIImage>()

extension UIImageView {
    func downloadImage(urlString: String) {
        image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            image = cachedImage
            return
        }
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, _, error in
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        self.image = downloadedImage
                        imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    }
                }
            }.resume()
        }
    }
}
