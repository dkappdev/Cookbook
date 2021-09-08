//
//  AnyCodingKey.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 08.09.2021.
//

import Foundation

/// A custom struct that adopts `CodingKey` protocol. This class allows code to access arbitrary JSON keys.
public struct AnyCodingKey: CodingKey {
    public var stringValue: String
    
    public init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    public var intValue: Int?
    
    public init(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }
}
