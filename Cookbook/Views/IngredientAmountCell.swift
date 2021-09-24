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
    
    public static let reuseIdentifier = "IngredientAmountCell"
    
    // MARK: - Initializers
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    // MARK: - Layout setup
    
    public override func layoutSubviews() {
        setupLayout()
    }
    
    private func setupLayout() {
        isAccessibilityElement = true
        
        // Ingredient amount label
        
        addSubview(ingredientAmountLabel)
        ingredientAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ingredientAmountLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ingredientAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            ingredientAmountLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Ingredient name label
        
        addSubview(ingredientNameLabel)
        ingredientNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ingredientNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ingredientNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            ingredientNameLabel.bottomAnchor.constraint(equalTo: ingredientAmountLabel.topAnchor)
        ])
        
        // Ingredient image view
        
        let containerView = UIView()
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: ingredientNameLabel.topAnchor, constant: -8)
        ])
        
        containerView.layer.masksToBounds = false
        containerView.layer.shadowRadius = 6
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        ingredientImageView.layer.cornerRadius = 12
        ingredientImageView.layer.masksToBounds = true
        
        containerView.addSubview(ingredientImageView)
        ingredientImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ingredientImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            ingredientImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            ingredientImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            ingredientImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}
