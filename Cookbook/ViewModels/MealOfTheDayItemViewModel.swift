//
//  MealOfTheDayItemViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 13.09.2021.
//

import UIKit

public class MealOfTheDayItemViewModel: ItemViewModel {
    
    // MARK: - Properties
    
    public var reuseIdentifier: String = MealOfTheDayCell.reuseIdentifier
    
    public let mealInfo: FullMealInfo
    public let mealImage: UIImage
    
    // MARK: - Initializers
    
    public init(mealInfo: FullMealInfo, mealImage: UIImage) {
        self.mealInfo = mealInfo
        self.mealImage = mealImage
    }
    
    // MARK: - Setup
    
    public func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? MealOfTheDayCell else { return }
        cell.mealNameLabel.text = mealInfo.mealName
        cell.mealAreaLabel.text = mealInfo.areaInfo.prettyString
        cell.mealCategoryLabel.text = mealInfo.category
        cell.mealImageView.image = mealImage
    }
}
