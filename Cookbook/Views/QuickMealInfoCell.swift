//
//  QuickMealInfoCell.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 21.09.2021.
//

import UIKit

public class QuickMealInfoCell: UICollectionViewCell {
    
    // MARK: - Views
    
    public let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        // Allow OS to produce descriptions of meal images
        imageView.isAccessibilityElement = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public let mealNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
        return label
    }()
    
    public let mealAreaLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        return label
    }()
    
    public let mealCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        return label
    }()
    
    public let addToFavoritesButton: UIButton = {
        let button = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: UIFont.TextStyle.title1.metrics.scaledValue(for: 22), weight: .bold, scale: .default)
        button.setImage(UIImage(systemName: "heart", withConfiguration: symbolConfiguration), for: .normal)
        button.accessibilityLabel = NSLocalizedString("add_to_favorites_button_accessibility_label", comment: "")
        return button
    }()
    
    // MARK: - Instance properties
    
    public let isCurrentMealAddedToFavorites = false
    
    // MARK: - Static properties
    
    public static let reuseIdentifier = "QuickMealInfo"
    
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
        
        // Meal image view
        
        addSubview(mealImageView)
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mealImageView.topAnchor.constraint(equalTo: topAnchor),
            mealImageView.heightAnchor.constraint(equalToConstant: 120),
            mealImageView.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        // Meal name label
        
        addSubview(mealNameLabel)
        mealNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealNameLabel.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: 16),
            mealNameLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        // Add to favorites button
        
        addSubview(addToFavoritesButton)
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addToFavoritesButton.leadingAnchor.constraint(equalTo: mealNameLabel.trailingAnchor, constant: 16),
            addToFavoritesButton.firstBaselineAnchor.constraint(equalTo: mealNameLabel.firstBaselineAnchor),
            addToFavoritesButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // Setting up content hugging priority to make sure button is not stretched out horizontally
        
        mealImageView.setContentHuggingPriority(UILayoutPriority(752), for: .horizontal)
        mealNameLabel.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        addToFavoritesButton.setContentHuggingPriority(UILayoutPriority(751), for: .horizontal)
        
        // Updating 'Add to Favorites' button to use the appropriate SF Symbol size
        updateAddToFavoritesButton(isAddedToFavorites: isCurrentMealAddedToFavorites)
        
        // Calculating height for area and category labels
        
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = "Arbitrary text".boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: mealAreaLabel.font ?? .preferredFont(forTextStyle: .body)], context: nil)
        let areaLabelHeight = boundingBox.height
        
        // Meal area blur effect + label
        
        let areaEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        areaEffect.clipsToBounds = true
        areaEffect.layer.cornerRadius = (areaLabelHeight + 8) / 2
        
        addSubview(areaEffect)
        areaEffect.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            areaEffect.leadingAnchor.constraint(equalTo: mealNameLabel.leadingAnchor),
            areaEffect.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 8)
        ])
        
        areaEffect.contentView.addSubview(mealAreaLabel)
        mealAreaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealAreaLabel.leadingAnchor.constraint(equalTo: areaEffect.leadingAnchor, constant: 12),
            mealAreaLabel.trailingAnchor.constraint(equalTo: areaEffect.trailingAnchor, constant: -12),
            mealAreaLabel.topAnchor.constraint(equalTo: areaEffect.topAnchor, constant: 4),
            mealAreaLabel.bottomAnchor.constraint(equalTo: areaEffect.bottomAnchor, constant: -4)
        ])
        
        // Meal category blur effect + label
        
        let categoryEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        categoryEffect.clipsToBounds = true
        categoryEffect.layer.cornerRadius = (areaLabelHeight + 8) / 2
        
        addSubview(categoryEffect)
        categoryEffect.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryEffect.leadingAnchor.constraint(equalTo: areaEffect.trailingAnchor, constant: 8),
            categoryEffect.bottomAnchor.constraint(equalTo: areaEffect.bottomAnchor)
        ])
        
        categoryEffect.contentView.addSubview(mealCategoryLabel)
        mealCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealCategoryLabel.leadingAnchor.constraint(equalTo: categoryEffect.leadingAnchor, constant: 12),
            mealCategoryLabel.trailingAnchor.constraint(equalTo: categoryEffect.trailingAnchor, constant: -12),
            mealCategoryLabel.topAnchor.constraint(equalTo: categoryEffect.topAnchor, constant: 4),
            mealCategoryLabel.bottomAnchor.constraint(equalTo: categoryEffect.bottomAnchor, constant: -4)
        ])
    }
    
    /// Updates 'Add to Favorites' button icon and size based. Chooses icon based on whether or not current meal is added to favorites. Adjusts button size using Dynamic Type.
    /// - Parameter isAddedToFavorites: this parameter is used to set the appropriate icon based on whether or not current meal is added to favorites
    func updateAddToFavoritesButton(isAddedToFavorites: Bool) {
        let sfSymbolName = isAddedToFavorites ? "heart.fill" : "heart"
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: UIFont.TextStyle.title1.metrics.scaledValue(for: 22), weight: .semibold, scale: .default)
        addToFavoritesButton.setImage(UIImage(systemName: sfSymbolName, withConfiguration: symbolConfiguration), for: .normal)
    }
}
