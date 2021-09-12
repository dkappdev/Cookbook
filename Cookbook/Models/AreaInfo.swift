//
//  AreaInfo.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

/// A type that represents information about meal origin area.
public struct AreaInfo {
    public var name: String
    public var flagEmoji: String
    
    public var prettyString: String {
        "\(flagEmoji) \(name.capitalized)"
    }
    
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
    
    public init(name: String) {
        self.name = name
        
        let lowercaseName = name.lowercased()
        
        if let flag = Self.nameToFlagMap[lowercaseName] {
            self.flagEmoji = flag
        } else {
            self.flagEmoji = "🇺🇳"
        }
    }
}

extension AreaInfo: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AnyCodingKey.self)
        
        let name = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "strArea"))
        
        self.init(name: name)
    }
}
