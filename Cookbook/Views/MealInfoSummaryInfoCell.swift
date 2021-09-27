//
//  MealInfoSummaryInfoCell.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 21.09.2021.
//

import UIKit

/// Collection view cell that displays meal's photo, name, origin, and category, along with an 'Add to Favorites' button
public class MealInfoSummaryInfoCell: UICollectionViewCell {
    
    // MARK: - Views
    
    public let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
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
    
    /// The tap gesture recognizer for image view
    public var imageTapGestureRecognizer: UITapGestureRecognizer?
    
    // MARK: - Static properties
    
    public static let reuseIdentifier = "MealInfoSummary"
    
    public static let imageSize: CGFloat = 120
    public static var textHeight: CGFloat {
        // two lines of name label + (area/category label + top/bottom padding) * 2 + space between area and category effect + space between name label and area effect
        UILabel.labelHeight(for: .preferredFont(forTextStyle: .title2)) * 2 + (UILabel.labelHeight(for: .preferredFont(forTextStyle: .body)) + 8) * 2 + 8 + 8
    }
    
    // MARK: - Initializers
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            mealImageView.heightAnchor.constraint(equalToConstant: Self.imageSize),
            mealImageView.widthAnchor.constraint(equalToConstant: Self.imageSize)
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
        
        // Calculating height for area and category labels
        
        let areaLabelHeight = UILabel.labelHeight(for: mealAreaLabel.font)
        
        // Meal area blur effect + label
        
        let areaEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        areaEffect.clipsToBounds = true
        areaEffect.layer.cornerRadius = (areaLabelHeight + 8) / 2
        
        addSubview(areaEffect)
        areaEffect.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            areaEffect.leadingAnchor.constraint(equalTo: mealNameLabel.leadingAnchor),
            areaEffect.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 8),
            areaEffect.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
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
            categoryEffect.leadingAnchor.constraint(equalTo: mealNameLabel.leadingAnchor),
            categoryEffect.topAnchor.constraint(equalTo: areaEffect.bottomAnchor, constant: 8),
            categoryEffect.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
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
    
    // MARK: - Gesture recognizers
    
    public func addImageTapGestureRecognizer(_ tapGestureRecognizer: UITapGestureRecognizer) {
        self.imageTapGestureRecognizer = tapGestureRecognizer
        mealImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    public func removeImageTapGestureRecognizer() {
        if let tapGestureRecognizer = imageTapGestureRecognizer {
            mealImageView.removeGestureRecognizer(tapGestureRecognizer)
        }
        imageTapGestureRecognizer = nil
    }
}
