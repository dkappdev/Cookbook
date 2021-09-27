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
    
    /// Action to perform when user taps on the 'toggle favorite' button
    private var toggleFavoriteAction: ((FullMealInfo) -> Void)? = nil
    
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
        
        cell.updateAddToFavoritesButton(isAddedToFavorites: UserSettings.shared.favoriteMeals.contains(mealInfo))
        
        // Remembering most recent cell
        mostRecentCell = cell
        
        // Setting up labels and image view
        cell.mealNameLabel.text = mealInfo.mealName
        cell.mealAreaLabel.text = mealInfo.areaInfo.prettyString
        cell.mealCategoryLabel.text = mealInfo.category
        
        // Setting up accessibility information
        cell.mealAreaLabel.accessibilityLabel = mealInfo.areaInfo.name
        cell.addToFavoritesButton.accessibilityLabel = NSLocalizedString("remove_from_favorites_button_accessibility_label", comment: "")
        
        // Removing old gesture recognizer and button target since cell might have been reused
        cell.removeImageTapGestureRecognizer()
        cell.addToFavoritesButton.removeTarget(nil, action: nil, for: .allEvents)
        
        if let image = image {
            cell.mealImageView.image = image
            // If there is an image, configure the tap gesture
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openImage(gestureRecognizer:)))
            cell.addImageTapGestureRecognizer(tapGestureRecognizer)
            cell.addToFavoritesButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
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
                        mostRecentCell.addToFavoritesButton.addTarget(self, action: #selector(self.toggleFavorite), for: .touchUpInside)
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
    
    public func setToggleFavoriteAction(_ action: @escaping (FullMealInfo) -> Void) {
        toggleFavoriteAction = action
    }
    
    @objc private func openImage(gestureRecognizer: UITapGestureRecognizer) {
        guard let image = image else { return }
        openImageAction?(image)
    }
    
    @objc private func toggleFavorite() {
        toggleFavoriteAction?(mealInfo)
        mostRecentCell?.updateAddToFavoritesButton(isAddedToFavorites: UserSettings.shared.favoriteMeals.contains(mealInfo))
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(mealInfo)
    }
}

public func == (lhs: MealInfoSummaryItemViewModel, rhs: MealInfoSummaryItemViewModel) -> Bool {
    return lhs.mealInfo == rhs.mealInfo
}
