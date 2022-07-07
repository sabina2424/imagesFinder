//
//  ImagesServices.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import Foundation

protocol ImagesNetworkServiceProtocol {
    typealias CompletionHandler = (Result<ResponseModel, NetworkError>) -> Void
    
    func getPhotos(image: String, tbm: String, tbs: String, page: Int?, lang: String?, country: String?,
                   completion: @escaping CompletionHandler)
  
}

class ImagesNetworkService: ImagesNetworkServiceProtocol {
    let service: NetworkManager
    
    init(service: NetworkManager = NetworkManager()) {
        self.service = service
    }
    
    func getPhotos(image: String, tbm: String, tbs: String, page: Int?, lang: String? = nil, country: String? = nil, completion: @escaping CompletionHandler) {
        service.request(endpoint: ImagesEndPoints.getPhotos(image: image, tbm: tbm, tbs: tbs, page: page ?? 0, lang: lang ?? "", country: country ?? ""), completion: completion)
    }
}
