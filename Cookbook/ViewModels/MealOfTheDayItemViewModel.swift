//
//  MealOfTheDayItemViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 13.09.2021.
//

import UIKit

public class MealOfTheDayItemViewModel: BaseItemViewModel {
    
    // MARK: - Properties
    
    public override var reuseIdentifier: String {
        MealOfTheDayCell.reuseIdentifier
    }
    
    public let mealInfo: FullMealInfo
    public let mealImage: UIImage
    
    // MARK: - Initializers
    
    /// Creates a new meal item view model
    /// - Parameters:
    ///   - mealInfo: meal information
    ///   - mealImage: image of the meal
    public init(mealInfo: FullMealInfo, mealImage: UIImage) {
        self.mealInfo = mealInfo
        self.mealImage = mealImage
    }
    // MARK: - Setup
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? MealOfTheDayCell else { return }
        cell.mealNameLabel.text = mealInfo.mealName
        cell.mealAreaLabel.text = mealInfo.areaInfo.prettyString
        cell.mealCategoryLabel.text = mealInfo.category
        cell.mealImageView.image = mealImage
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(mealInfo)
    }
}

// Conforming to Equatable
public func == (lhs: MealOfTheDayItemViewModel, rhs: MealOfTheDayItemViewModel) -> Bool {
    return lhs.mealInfo == rhs.mealInfo
}
