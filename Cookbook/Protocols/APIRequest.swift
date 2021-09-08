//
//  APIRequest.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 08.09.2021.
//

import UIKit

protocol APIRequest {
    associatedtype Response
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var request: URLRequest { get }
}

extension APIRequest {
    var host: String { "www.themealdb.com" }
    var port: Int { 443 }
}

extension APIRequest {
    var queryItems: [URLQueryItem]? { nil }
}

extension APIRequest {
    var request: URLRequest {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = host
        components.port = port
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            fatalError("Failed to create URL for URLRequest")
        }
        
        return URLRequest(url: url)
    }
}
