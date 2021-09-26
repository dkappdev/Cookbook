//
//  MealInfoSummaryItemViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 23.09.2021.
//

import UIKit

public class MealInfoSummaryItemViewModel: BaseItemViewModel {
    // MARK: - Properties
    
    public override var reuseIdentifier: String {
        MealInfoSummaryInfoCell.reuseIdentifier
    }
    
    /// Cached version of downloaded image
    private var image: UIImage?
    /// Indicates whether or not an image has already been requested
    private var hasRequestedImage = false
    /// Cell that most recently called `setup(_:in:at:)`. This property is used to properly set category image after receiving it from network.
    private var mostRecentCell: MealInfoSummaryInfoCell?
    
    /// Action to perform when user taps on the meal image
    private var openImageAction: ((UIImage) -> Void)? = nil
    
    public let mealInfo: FullMealInfo
    
    // MARK: - Initializers
    
    /// Creates a new quick meal info item view model
    /// - Parameter mealInfo: meal information
    public init(mealInfo: FullMealInfo) {
        self.mealInfo = mealInfo
    }
    
    // MARK: - Setup
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? MealInfoSummaryInfoCell else { return }
        
        // Remembering most recent cell
        mostRecentCell = cell
        
        // Setting up labels and image view
        cell.mealNameLabel.text = mealInfo.mealName
        cell.mealAreaLabel.text = mealInfo.areaInfo.prettyString
        cell.mealCategoryLabel.text = mealInfo.category
        
        // Setting up accessibility information
        cell.mealAreaLabel.accessibilityLabel = mealInfo.areaInfo.name
        
        // Removing old gesture recognizer since cell might have been reused
        cell.removeImageTapGestureRecognizer()
        
        if let image = image {
            cell.mealImageView.image = image
            // If there is an image, configure the tap gesture
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openImage(gestureRecognizer:)))
            cell.addImageTapGestureRecognizer(tapGestureRecognizer)
        }
        
        // Requesting image only if we haven't requested it before
        guard !hasRequestedImage else { return }
        
        hasRequestedImage = true
        ArbitraryImageRequest(imageURL: mealInfo.imageURL).send { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    if let mostRecentCell = self.mostRecentCell,
                       collectionView.indexPath(for: mostRecentCell) == indexPath {
                        mostRecentCell.mealImageView.image = image
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openImage(gestureRecognizer:)))
                        mostRecentCell.addImageTapGestureRecognizer(tapGestureRecognizer)
                    }
                }
                self.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func setOpenImageAction(_ action: @escaping (UIImage) -> Void) {
        openImageAction = action
    }
    
    @objc private func openImage(gestureRecognizer: UITapGestureRecognizer) {
        guard let image = image else { return }
        openImageAction?(image)
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(mealInfo)
    }
}

public func == (lhs: MealInfoSummaryItemViewModel, rhs: MealInfoSummaryItemViewModel) -> Bool {
    return lhs.mealInfo == rhs.mealInfo
}
