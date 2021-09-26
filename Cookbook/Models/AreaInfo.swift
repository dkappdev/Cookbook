//
//  AreaInfo.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

/// A type that represents information about meal origin area.
public struct AreaInfo {
    
    // MARK: - Properties
    
    private static var nameToFlagMap = [
        "american": "🇺🇸",
        "british": "🇬🇧",
        "canadian": "🇨🇦",
        "chinese": "🇨🇳",
        "croatian": "🇭🇷",
        "dutch": "🇳🇱",
        "egyptian": "🇪🇬",
        "french": "🇫🇷",
        "greek": "🇬🇷",
        "indian": "🇮🇳",
        "irish": "🇮🇪",
        "italian": "🇮🇹",
        "jamaican": "🇯🇲",
        "japanese": "🇯🇵",
        "kenyan": "🇰🇪",
        "malaysian": "🇲🇾",
        "mexican": "🇲🇽",
        "moroccan": "🇲🇦",
        "polish": "🇵🇱",
        "portuguese": "🇵🇹",
        "russian": "🇷🇺",
        "spanish": "🇪🇸",
        "thai": "🇹🇭",
        "tunisian": "🇹🇳",
        "turkish": "🇹🇷",
        "vietnamese": "🇻🇳",
        "unknown": "🇺🇳"
    ]
    
    public var name: String
    public var flagEmoji: String
    
    // MARK: - Computed Properties
    
    public var prettyString: String {
        "\(flagEmoji) \(name.capitalized)"
    }
    
    // MARK: - Instances
    
    public static let empty = AreaInfo()
    
    // MARK: - Initializers
    
    /// Creates area info with the specified area name
    /// - Parameter name: area name
    public init(name: String) {
        let lowercaseName = name.lowercased()
        
        if lowercaseName == "unknown" {
            self.name = "Other"
        } else {
            self.name = name
        }
        
        if let flag = Self.nameToFlagMap[lowercaseName] {
            self.flagEmoji = flag
        } else {
            self.flagEmoji = "🇺🇳"
        }
    }
    
    /// Creates an empty instance of area info
    private init() {
        self.name = "   "
        self.flagEmoji = ""
    }
}

extension AreaInfo: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AnyCodingKey.self)
        
        let name = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "strArea"))
        
        self.init(name: name)
    }
}
