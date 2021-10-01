//
//  APIRequest.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 08.09.2021.
//

import UIKit

/// Set of properties common to all API Requests. Concrete types must explicitly specify `associatedtype Response`, `path` and `queryItems` (if needed). `URLRequest` will then be automatically created by default implementation.
public protocol APIRequest {
    associatedtype Response
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var request: URLRequest { get }
}

// Provides host property for the application
extension APIRequest {
    public var host: String { "www.themealdb.com" }
}

// Provides default query items
extension APIRequest {
    public var queryItems: [URLQueryItem]? { nil }
}

// Automatically creates URLRequest for concrete APIRequest instances with initialized fields
extension APIRequest {
    public var request: URLRequest {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            fatalError("Failed to create URL for URLRequest")
        }
        
        return URLRequest(url: url)
    }
}

// Provides a helper function for decoding server responses for arbitrary decodable types
extension APIRequest where Response: Decodable {
    public func send(completion: @escaping (Result<Response, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

public enum ImageRequestError: Error {
    case couldNotInitializeFromData(imageURL: URL)
}

// Provides a helper function for decoding images returned from server
extension APIRequest where Response == UIImage {
    
    public func send(completion: @escaping (Result<Response, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data,
               let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(ImageRequestError.couldNotInitializeFromData(imageURL: request.url!)))
            }
        }.resume()
    }
}
