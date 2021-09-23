//
//  QuickMealInfoItemViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 23.09.2021.
//

import UIKit

public class QuickMealInfoItemViewModel: BaseItemViewModel {
    // MARK: - Properties
    
    public override var reuseIdentifier: String {
        QuickMealInfoCell.reuseIdentifier
    }
    
    private var image: UIImage?
    private var hasRequestedImage = false
    private var mostRecentCell: QuickMealInfoCell?
    
    public let mealInfo: FullMealInfo
    
    // MARK: - Initializers
    
    /// Creates a new quick meal info item view model
    /// - Parameter mealInfo: meal information
    public init(mealInfo: FullMealInfo) {
        self.mealInfo = mealInfo
    }
    
    // MARK: - Setup
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? QuickMealInfoCell else { return }
        cell.mealNameLabel.text = mealInfo.mealName
        cell.mealAreaLabel.text = mealInfo.areaInfo.prettyString
        cell.mealCategoryLabel.text = mealInfo.category
        
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

public func == (lhs: QuickMealInfoItemViewModel, rhs: QuickMealInfoItemViewModel) -> Bool {
    return lhs.mealInfo == rhs.mealInfo
}
