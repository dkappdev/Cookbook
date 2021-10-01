//
//  ShortMealInfoItemViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 26.09.2021.
//

import UIKit

public class ShortMealInfoItemViewModel: BaseItemViewModel {
    
    // MARK: - Properties
    
    public override var reuseIdentifier: String {
        ShortMealInfoCell.reuseIdentifier
    }
    
    /// Cached version of downloaded image
    private var image: UIImage?
    /// Indicates whether or not an image has already been requested
    private var hasRequestedImage = false
    /// Cell that most recently called `setup(_:in:at:)`. This property is used to properly set category image after receiving it from network.
    private var mostRecentCell: ShortMealInfoCell?
    
    public let mealInfo: ShortMealInfo
    
    // MARK: - Initializers
    
    /// Creates a new short meal info item view model with specified meal information
    /// - Parameter mealInfo: meal information
    public init(mealInfo: ShortMealInfo) {
        self.mealInfo = mealInfo
    }
    
    // MARK: - Cell setup
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? ShortMealInfoCell else { return }
        
        // Remembering most recent cell
        mostRecentCell = cell
        
        // Setting up cell's label and image view
        
        cell.mealNameLabel.text = mealInfo.mealName
        
        if let image = image {
            cell.mealImageView.image = image
        } else {
            cell.mealImageView.image = nil
        }
        
        // Setting up accessibility information
        cell.accessibilityHint = NSLocalizedString("button_accessibility_hint", comment: "")
        cell.accessibilityLabel = mealInfo.mealName
        
        // Requesting image only if it hasn't already been requested
        guard !hasRequestedImage else { return }
        
        hasRequestedImage = true
        ArbitraryImageRequest(imageURL: mealInfo.imageURL).send { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    // Setting up meal image only if the cell hasn't been reused after the initial request
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
        hasher.combine(mealInfo.mealID)
    }
}

public func == (lhs: ShortMealInfoItemViewModel, rhs: ShortMealInfoItemViewModel) -> Bool {
    return lhs.mealInfo.mealID == rhs.mealInfo.mealID
}
