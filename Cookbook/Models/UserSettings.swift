//
//  UserSettings.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 27.09.2021.
//

import Foundation

/// Singleton class responsible for managing user settings
public class UserSettings {
    
    // MARK: - Instances
    
    public static let shared = UserSettings()
    
    private init() { }
    
    // MARK: - UserDefaults management
    
    private let defaults = UserDefaults.standard
    
    private enum Setting {
        public static let favoriteMeals = "favoriteMeals"
    }
    
    // MARK: - Utility functions
    
    private func archiveJSON<T: Encodable>(key: String, value: T) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        let jsonString = String(data: data, encoding: .utf8)
        defaults.set(jsonString, forKey: key)
    }
    
    private func unarchiveJSON<T: Decodable>(key: String) -> T? {
        guard let string = defaults.string(forKey: key),
              let data = string.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - Stored properties
    
    public var favoriteMeals: [FullMealInfo] {
        get {
            unarchiveJSON(key: Setting.favoriteMeals) ?? []
        }
        set {
            archiveJSON(key: Setting.favoriteMeals, value: newValue)
        }
    }
    
    // MARK: - Data manipulation
    
    func toggleFavorite(for meal: FullMealInfo) {
        var favorites = favoriteMeals
        
        if favorites.contains(meal) {
            favorites = favorites.filter { $0 != meal }
        } else {
            favorites.append(meal)
        }
        
        favoriteMeals = favorites
    }
}
