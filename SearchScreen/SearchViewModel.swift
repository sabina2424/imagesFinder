//
//  SearchViewModel.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import Foundation

class SearchViewModel {
    let service: ImagesNetworkServiceProtocol
    var inputData: SearchInputData
    
    init(service: ImagesNetworkServiceProtocol = ImagesNetworkService(), inputData: SearchInputData) {
        self.service = service
        self.inputData = inputData
    }
    
    var changeHandler: ((SearchState) -> Void)?
    var photos: [ImagesResult] = []
    var currentPage = 0
    var isPaginating: Bool = false
    
    func fetchData(pagination: Bool = false) {
        changeHandler?(.isFetching(true))
            
        isPaginating = pagination == true
    
        
        service.getPhotos(image: inputData.image ?? "", tbm: inputData.tbm, tbs: "itp:photos", page: currentPage, lang: inputData.lang, country: inputData.country) { [weak self] result in
            guard let self = self else { return }
            self.changeHandler?(.isFetching(false))
            switch result {
            case .success(let response):
                self.photos.append(contentsOf: response.imagesResults ?? [])
                self.isPaginating = pagination != true
                self.changeHandler?(.loaded)
            case .failure(let error):
                self.changeHandler?(.error(error))
            }
        }
    }
}
