//
//  ImagesEndPoints.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import Foundation

enum ImagesEndPoints: EndPoint {
    
    private static let apiKey = "f2ba8cd4feaea6b7f7aec79d899e689bfb971848541c123eeb4886312ec78fed"
    
    case getPhotos(image: String,
                   tbm: String,
                   tbs: String,
                   page: Int,
                   lang: String,
                   country: String)
    
    var scheme: HTTPScheme {
        return .https
    }
    
    var baseURL: String {
        return "serpapi.com"
    }
    
    var path: String {
        switch self {
        case .getPhotos:
            return "/search"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case let .getPhotos(image, tbm, tbs, page, lang, country):
            return [ URLQueryItem(name: "q", value: image),
                     URLQueryItem(name: "engine", value: "google"),
                     URLQueryItem(name: "device", value: "mobile"),
                     URLQueryItem(name: "filter", value: "0"),
                     URLQueryItem(name: "tbm", value: tbm),
                     URLQueryItem(name: "tbs", value: tbs),
                     URLQueryItem(name: "start", value: "\(20 * page)"),
                     URLQueryItem(name: "num", value: "20"),
                     URLQueryItem(name: "hl", value: lang),
                     URLQueryItem(name: "gl", value: country),
                     URLQueryItem(name: "api_key", value: ImagesEndPoints.apiKey)]
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [HTTPHeaders : String] {
        let headers: [HTTPHeaders : String] = [.contentType : "application/json"]
        return headers
    }
    
    var body: Data? { return nil }
}
