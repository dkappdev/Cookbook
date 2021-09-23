//
//  MealOfTheDayCell.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 12.09.2021.
//

import UIKit

/// Collection view cell that displays meal of the day
public class MealOfTheDayCell: UICollectionViewCell {
    
    // MARK: - Views
    
    public let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isAccessibilityElement = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public let mealNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        return label
    }()
    
    public let mealAreaLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        label.textAlignment = .center
        return label
    }()
    
    public let mealCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Static properties
    
    public static let reuseIdentifier = "MealOfTheDay"
    
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
        // Creating shadow
        
        isAccessibilityElement = true
        
        layer.shadowRadius = 12
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.masksToBounds = false
        
        // Container view
        // This container holds all subviews
        // This is necessary because setting `clipsToBounds` property to `true` on the root view causes the drop shadow to disappear
        // By creating a separate container view we can properly clip subviews and create rounded corners
        // while keeping the drop shadow on the main view
        
        let containerView = UIView()
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        containerView.backgroundColor = .systemGray4
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // Calculating height for labels
        
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let areaBoundingBox = (mealAreaLabel.text ?? "").boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: mealAreaLabel.font ?? .preferredFont(forTextStyle: .body)], context: nil)
        let nameBoundingBox = (mealNameLabel.text ?? "").boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: mealNameLabel.font ?? .preferredFont(forTextStyle: .body)], context: nil)
        
        // Meal image view
        
        containerView.addSubview(mealImageView)
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mealImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mealImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // Bottom blur effect
        
        let bottomEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        bottomEffect.translatesAutoresizingMaskIntoConstraints = false
        bottomEffect.clipsToBounds = true
        containerView.addSubview(bottomEffect)
        
        NSLayoutConstraint.activate([
            bottomEffect.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            bottomEffect.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomEffect.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomEffect.heightAnchor.constraint(equalToConstant: areaBoundingBox.height + nameBoundingBox.height + 8 + 3 * 8)
        ])
        
        // Meal area blur effect + label
        
        let areaEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        areaEffect.translatesAutoresizingMaskIntoConstraints = false
        areaEffect.clipsToBounds = true
        areaEffect.layer.cornerRadius = (areaBoundingBox.height + 8) / 2
        
        containerView.addSubview(areaEffect)
        
        areaEffect.contentView.addSubview(mealAreaLabel)
        mealAreaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealAreaLabel.leadingAnchor.constraint(equalTo: areaEffect.leadingAnchor, constant: 12),
            mealAreaLabel.trailingAnchor.constraint(equalTo: areaEffect.trailingAnchor, constant: -12),
            mealAreaLabel.topAnchor.constraint(equalTo: areaEffect.topAnchor, constant: 4),
            mealAreaLabel.bottomAnchor.constraint(equalTo: areaEffect.bottomAnchor, constant: -4),
        ])
        
        NSLayoutConstraint.activate([
            areaEffect.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            areaEffect.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
        ])
        
        // Meal category blur effect + label
        
        let categoryEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        categoryEffect.translatesAutoresizingMaskIntoConstraints = false
        categoryEffect.clipsToBounds = true
        categoryEffect.layer.cornerRadius = (areaBoundingBox.height + 8) / 2
        
        containerView.addSubview(categoryEffect)
        
        categoryEffect.contentView.addSubview(mealCategoryLabel)
        mealCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealCategoryLabel.leadingAnchor.constraint(equalTo: categoryEffect.leadingAnchor, constant: 12),
            mealCategoryLabel.trailingAnchor.constraint(equalTo: categoryEffect.trailingAnchor, constant: -12),
            mealCategoryLabel.topAnchor.constraint(equalTo: categoryEffect.topAnchor, constant: 4),
            mealCategoryLabel.bottomAnchor.constraint(equalTo: categoryEffect.bottomAnchor, constant: -4),
        ])
        
        NSLayoutConstraint.activate([
            categoryEffect.leadingAnchor.constraint(equalTo: areaEffect.trailingAnchor, constant: 8),
            categoryEffect.bottomAnchor.constraint(equalTo: areaEffect.bottomAnchor)
        ])
        
        // Meal name label
        
        containerView.addSubview(mealNameLabel)
        mealNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mealNameLabel.bottomAnchor.constraint(equalTo: areaEffect.topAnchor, constant: -8),
            mealNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
}
