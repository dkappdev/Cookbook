//
//  IngredientAmountItemViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 24.09.2021.
//

import UIKit

public class IngredientAmountItemViewModel: BaseItemViewModel {
    
    // MARK: - Properties
    
    public override var reuseIdentifier: String {
        IngredientAmountCell.reuseIdentifier
    }
    
    /// Cached version of downloaded image
    private var image: UIImage?
    /// Indicates whether or not an image has already been requested
    private var hasRequestedImage = false
    /// Cell that most recently called `setup(_:in:at:)`. This property is used to properly set ingredient image after receiving it from network.
    private var mostRecentCell: IngredientAmountCell?
    
    /// Action to perform when user taps on the ingredient image
    private var openImageAction: ((UIImage) -> Void)? = nil
    
    public let ingredientAmount: IngredientAmount
    
    // MARK: - Initializers
    
    /// Creates a new ingredient amount item view model
    /// - Parameter ingredientAmount: ingredient measurements
    public init(ingredientAmount: IngredientAmount) {
        self.ingredientAmount = ingredientAmount
    }
    
    // MARK: - Cell setup
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? IngredientAmountCell else { return }
        
        // Remembering most recent cell
        mostRecentCell = cell
        
        // Setting up cell's labels and image view
        cell.ingredientNameLabel.text = ingredientAmount.name
        cell.ingredientAmountLabel.text = ingredientAmount.amount
        
        // Removing old gesture recognizer since cell might have been reused
        cell.removeImageTapGestureRecognizer()
        
        if let image = image {
            cell.ingredientImageView.image = image
            cell.ingredientImageView.backgroundColor = .white
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openImage(gestureRecognizer:)))
            cell.addImageTapGestureRecognizer(tapGestureRecognizer)
        } else {
            cell.ingredientImageView.image = nil
            cell.ingredientImageView.backgroundColor = .systemGray4
        }
        
        // Setting up accessibility information
        cell.accessibilityLabel = "\(ingredientAmount.name). \(ingredientAmount.amount)"
        cell.accessibilityHint = nil
        
        // Requesting image only if an image hasn't already been requested
        guard !hasRequestedImage else { return }
        
        hasRequestedImage = true
        IngredientImageRequest(ingredientName: ingredientAmount.name).send { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    // Setting the image only if the cell was not reused after making the request
                    if let mostRecentCell = self.mostRecentCell,
                       collectionView.indexPath(for: mostRecentCell) == indexPath {
                        mostRecentCell.ingredientImageView.image = image
                        mostRecentCell.ingredientImageView.backgroundColor = .white
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openImage(gestureRecognizer:)))
                        cell.addImageTapGestureRecognizer(tapGestureRecognizer)
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
        hasher.combine(ingredientAmount.name)
    }
}

public func == (lhs: IngredientAmountItemViewModel, rhs: IngredientAmountItemViewModel) -> Bool {
    lhs.ingredientAmount.name == rhs.ingredientAmount.name
}
