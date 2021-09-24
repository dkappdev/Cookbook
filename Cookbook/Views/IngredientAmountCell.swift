//
//  IngredientAmountCell.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 24.09.2021.
//

import UIKit

/// Collection view cell that displays ingredient for a recipe
public class IngredientAmountCell: UICollectionViewCell {
    
    // MARK: - Views
    
    public let ingredientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray4
        imageView.isAccessibilityElement = false
        return imageView
    }()
    
    public let ingredientNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        return label
    }()
    
    public let ingredientAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        return label
    }()
    
    // MARK: - Static properties
    
    // MARK: - Initializers
    
    // MARK: - Layout setup
    
}
