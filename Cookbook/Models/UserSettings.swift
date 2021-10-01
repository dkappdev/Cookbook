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
        public static let mostRecentMealOfTheDayInfo = "mostRecentMealOfTheDayInfo"
        public static let mostRecentMealOfTheDayDate = "mostRecentMealOfTheDayDate"
        public static let recentMeals = "recentMeals"
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
    
    // MARK: - Computed properties
    
    public private(set) var favoriteMeals: [FullMealInfo] {
        get {
            unarchiveJSON(key: Setting.favoriteMeals) ?? []
        }
        set {
            archiveJSON(key: Setting.favoriteMeals, value: newValue)
        }
    }
    
    private var mostRecentMealOfTheDayInfo: FullMealInfo? {
        get {
            unarchiveJSON(key: Setting.mostRecentMealOfTheDayInfo)
        }
        set {
            archiveJSON(key: Setting.mostRecentMealOfTheDayInfo, value: newValue)
        }
    }
    
    private var mostRecentMealOfTheDayDate: Date? {
        get {
            unarchiveJSON(key: Setting.mostRecentMealOfTheDayDate)
        }
        set {
            archiveJSON(key: Setting.mostRecentMealOfTheDayDate, value: newValue)
        }
    }
    
    /// List of recents meals that user accessed through search. This list contains at most 6 elements. Most recent meals are stored at the beginning.
    public private(set) var recentMeals: [ShortMealInfo] {
        get {
            unarchiveJSON(key: Setting.recentMeals) ?? []
        }
        set {
            archiveJSON(key: Setting.recentMeals, value: newValue)
        }
    }
    
    // MARK: - Providing data
    
    public func mealOfTheDay(completion: @escaping (Result<FullMealInfo, Error>) -> Void) {
        // Making sure there was a cached meal before
        guard let mostRecentMealOfTheDayDate = mostRecentMealOfTheDayDate,
              let mostRecentMealOfTheDayInfo = mostRecentMealOfTheDayInfo else {
            RandomMealRequest().send { result in
                switch result {
                case .success(let response):
                    self.mostRecentMealOfTheDayInfo = response.mealInfo
                    self.mostRecentMealOfTheDayDate = Date()
                    completion(.success(response.mealInfo))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            return
        }
        
        if Calendar.current.isDateInToday(mostRecentMealOfTheDayDate) {
            // If meal of the day was already requested today, get the cached version
            completion(.success(mostRecentMealOfTheDayInfo))
        } else {
            // Otherwise request new meal from network
            RandomMealRequest().send { result in
                switch result {
                case .success(let response):
                    self.mostRecentMealOfTheDayInfo = response.mealInfo
                    self.mostRecentMealOfTheDayDate = Date()
                    completion(.success(response.mealInfo))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Data manipulation
    
    /// Toggles favorite status for a meal
    /// - Parameter meal: meal that is added to / removed from favorites
    func toggleFavorite(for meal: FullMealInfo) {
        var favorites = favoriteMeals
        
        if favorites.contains(meal) {
            favorites = favorites.filter { $0 != meal }
        } else {
            favorites.insert(meal, at: 0)
        }
        
        favoriteMeals = favorites
    }
    
    /// Adds a meal to the recent meals list
    /// - Parameter meal: meal that user has accessed
    func addRecentMeal(_ meal: ShortMealInfo) {
        var recents = recentMeals
        
        // Removing current meal from recents if it is there
        recents = recents.filter { $0 != meal }
        
        // Appending it to the array
        recents.insert(meal, at: 0)
        
        // If there are now more than 6 elements, remove the oldest element
        if recents.count > 6 {
            recents.removeLast()
        }
        
        recentMeals = recents
    }
}
