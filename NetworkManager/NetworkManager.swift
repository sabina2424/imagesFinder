//
//  NetworkManager.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import Foundation

final class NetworkManager {
    typealias CompletionHandler<T> = (Result<T,Error>) -> Void
    
    // MARK: - Properties
    private static let sessionConfiguration: URLSessionConfiguration = {
        var configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.timeoutIntervalForRequest = Constants.timeoutInterval
        return configuration
    }()
    
    private var session = URLSession(configuration: sessionConfiguration)
    
    private func buildURL(with endpoint: EndPoint) -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        return components
    }
    
    func request<T: Decodable>(endpoint: EndPoint, completion: @escaping (Result<T, NetworkError>) -> Void)  {
        let components = buildURL(with: endpoint)
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: Constants.timeoutInterval)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.httpBody = endpoint.body
        
        for (key, value) in endpoint.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key.rawValue)
        }
        
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async { [self] in
                if let httpResponse = response as? HTTPURLResponse {
                    let responseStatus = ResponseStatus(statusCode: httpResponse.statusCode)
                    switch responseStatus {
                    case .unauthorized:
                        completion(.failure(.unauthorized))
                    case .clientError:
                        completion(.failure(NetworkError.error(reason: error?.localizedDescription ?? "")))
                    default:
                        break
                    }
                }
                
                guard let data = data else { return }
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    print(String(describing: error))
                }
            }
        }
        task.resume()
    }
}
