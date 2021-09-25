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
    
    /// Cached version of downloaded image
    private var image: UIImage?
    /// Indicates whether or not an image has already been requested
    private var hasRequestedImage = false
    /// Cell that most recently called `setup(_:in:at:)`. This property is used to properly set category image after receiving it from network.
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
        
        // Remembering most recent cell
        mostRecentCell = cell
        
        // Setting up labels and image view
        cell.mealNameLabel.text = mealInfo.mealName
        cell.mealAreaLabel.text = mealInfo.areaInfo.prettyString
        cell.mealCategoryLabel.text = mealInfo.category
        
        if let image = image {
            cell.mealImageView.image = image
        }
        
        // Setting up accessibility information
        cell.accessibilityHint = NSLocalizedString("button_accessibility_hint", comment: "")
        cell.accessibilityLabel = "\(mealInfo.mealName). \(mealInfo.areaInfo.name). \(mealInfo.category)"
        
        // Requesting image only if this is not a stub cell and an image hasn't already been requested
        guard mealInfo != FullMealInfo.empty,
              !hasRequestedImage else { return }
        
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
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(mealInfo)
    }
}

// Conforming to Equatable
public func == (lhs: MealOfTheDayItemViewModel, rhs: MealOfTheDayItemViewModel) -> Bool {
    return lhs.mealInfo == rhs.mealInfo
}
