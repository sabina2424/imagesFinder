//
//  EndPoint.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import Foundation

import Foundation

protocol EndPoint {
    var scheme: HTTPScheme { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: HTTPMethod { get }
    var headers: [HTTPHeaders: String] { get }
    var body: Data? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum HTTPScheme: String {
    case http
    case https
}

enum HTTPHeaders: String {
    case contentType = "Content-Type"
    case accept = "Accept-Version"
    case contentEncoding = "Content-Encoding"
}

enum NetworkError: LocalizedError {
    case invalidURL
    case unauthorized
    case failed
    case network(Error)
    case error(reason: String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .unauthorized:
            return "Unauthorized User"
        case let .network(error):
            return error.localizedDescription
        case let .error(reason):
            return reason
        case .failed:
            return "No Data"
        }
    }
}

enum ResponseStatus {
    case success
    case badRequest
    case unauthorized
    case networkError
    case clientError
    
    init(statusCode: Int) {
        switch statusCode {
        case 200...299: self = .success
        case 400...499:
            if statusCode == 400 {
                self = .badRequest
            } else if statusCode == 401 {
                self = .unauthorized
            } else {
                self = .clientError
            }
        case 500...599: self = .networkError
        default: self = .networkError
        }
    }
}
