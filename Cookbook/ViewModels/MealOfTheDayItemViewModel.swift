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
    
    private var image: UIImage?
    private var hasRequestedImage = false
    private var mostRecentCell: MealOfTheDayCell?
    
    public let mealInfo: FullMealInfo
    
    // MARK: - Initializers
    
    /// Creates a new meal item view model
    /// - Parameters:
    ///   - mealInfo: meal information
    public init(mealInfo: FullMealInfo) {
        self.mealInfo = mealInfo
    }
    
    // MARK: - Setup
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? MealOfTheDayCell else { return }
        
        // Setting up labels
        cell.mealNameLabel.text = mealInfo.mealName
        cell.mealAreaLabel.text = mealInfo.areaInfo.prettyString
        cell.mealCategoryLabel.text = mealInfo.category
        
        cell.accessibilityHint = NSLocalizedString("button_accessibility_hint", comment: "")
        cell.accessibilityLabel = "\(mealInfo.mealName). \(mealInfo.areaInfo.name). \(mealInfo.category)"
        
        // Making sure this is not a stub cell
        guard mealInfo != FullMealInfo.empty else {
            return
        }
        
        // Requesting image from network
        
        mostRecentCell = cell
        
        if let image = image {
            DispatchQueue.main.async {
                cell.mealImageView.image = image
            }
        } else if !hasRequestedImage {
            hasRequestedImage = true
            ArbitraryImageRequest(imageURL: mealInfo.imageURL).send { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        if let mostRecentCell = self.mostRecentCell,
                            collectionView.indexPath(for: mostRecentCell) == indexPath {
                            mostRecentCell.mealImageView.image = image
                        }
                    }
                    self.image = image
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(mealInfo)
    }
}

// Conforming to Equatable
public func == (lhs: MealOfTheDayItemViewModel, rhs: MealOfTheDayItemViewModel) -> Bool {
    return lhs.mealInfo == rhs.mealInfo
}
