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
    
    public let categoryInfo: CategoryInfo
    
    // MARK: - Initializers
    
    /// Creates a new category item view model
    /// - Parameter categoryInfo: category information
    public init(categoryInfo: CategoryInfo) {
        self.categoryInfo = categoryInfo
    }
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? CategoryCell else { return }
        
        cell.categoryNameLabel.text = categoryInfo.categoryName
        cell.categoryImageView.image = nil
        cell.categoryImageView.backgroundColor = .systemGray4
        
        if let image = image {
            DispatchQueue.main.async {
                cell.categoryImageView.image = image
                cell.categoryImageView.backgroundColor = .white
            }
        } else {
            ArbitraryImageRequest(imageURL: categoryInfo.imageURL).send { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        // Setting the image only if the cell was not reused
                        if collectionView.indexPath(for: cell) == indexPath {
                            cell.categoryImageView.image = image
                            cell.categoryImageView.backgroundColor = .white
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
        hasher.combine(categoryInfo)
    }
}

public func == (lhs: CategoryItemViewModel, rhs: CategoryItemViewModel) -> Bool {
    lhs.categoryInfo == rhs.categoryInfo
}
