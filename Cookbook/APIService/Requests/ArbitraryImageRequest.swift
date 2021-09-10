//
//  ArbitraryImageRequest.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import UIKit

/// Request for getting arbitrary image from network
public struct ArbitraryImageRequest: APIRequest {
    public typealias Response = UIImage
    
    public var path: String { "" }
    
    public var request: URLRequest {
        URLRequest(url: imageURL)
    }
    
    public var imageURL: URL
}
