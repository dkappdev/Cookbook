//
//  CategoryItemViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 14.09.2021.
//

import UIKit

public class CategoryItemViewModel: BaseItemViewModel {
    // MARK: - Properties
    
    public override var reuseIdentifier: String {
        CategoryCell.reuseIdentifier
    }
    
    /// Cached version of downloaded image
    private var image: UIImage?
    /// Indicates whether or not an image has already been requested
    private var hasRequestedImage = false
    /// Cell that most recently called `setup(_:in:at:)`. This property is used to properly set category image after receiving it from network.
    private var mostRecentCell: CategoryCell?
    
    public let categoryInfo: CategoryInfo
    
    // MARK: - Initializers
    
    /// Creates a new category item view model
    /// - Parameter categoryInfo: category information
    public init(categoryInfo: CategoryInfo) {
        self.categoryInfo = categoryInfo
    }
    
    // MARK: - Cell setup
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? CategoryCell else { return }
        
        // Remembering most recent cell
        mostRecentCell = cell
        
        // Setting up cell's label and image view
        cell.categoryNameLabel.text = categoryInfo.categoryName
        
        if let image = image {
            cell.categoryImageView.image = image
            cell.categoryImageView.backgroundColor = .white
        } else {
            cell.categoryImageView.image = nil
            cell.categoryImageView.backgroundColor = .systemGray4
        }
        
        // Setting up accessibility information
        cell.accessibilityLabel = categoryInfo.categoryName
        cell.accessibilityHint = NSLocalizedString("button_accessibility_hint", comment: "")
        
        // Requesting image only if this is not a stub cell and an image hasn't already been requested
        guard categoryInfo != CategoryInfo.empty,
              !hasRequestedImage else { return }
        
        hasRequestedImage = true
        ArbitraryImageRequest(imageURL: categoryInfo.imageURL).send { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    // Setting the image only if the cell was not reused after making the request
                    if let mostRecentCell = self.mostRecentCell,
                       collectionView.indexPath(for: mostRecentCell) == indexPath {
                        mostRecentCell.categoryImageView.image = image
                        mostRecentCell.categoryImageView.backgroundColor = .white
                    }
                }
                self.image = image
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(categoryInfo)
    }
}

public func == (lhs: CategoryItemViewModel, rhs: CategoryItemViewModel) -> Bool {
    lhs.categoryInfo == rhs.categoryInfo
}
