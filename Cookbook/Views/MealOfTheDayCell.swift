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
        imageView.accessibilityLabel = NSLocalizedString("meal_of_the_day_image_accessibility_label", comment: "")
        imageView.accessibilityHint = NSLocalizedString("another_image_hit", comment: "")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public let mealNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    public let mealAreaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        return label
    }()
    
    public let mealCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
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
        backgroundColor = .systemGray4
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        // Calculating height for labels
        
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let areaBoundingBox = (mealAreaLabel.text ?? "").boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: mealAreaLabel.font ?? UIFont.preferredFont(forTextStyle: .body)], context: nil)
        let nameBoundingBox = (mealNameLabel.text ?? "").boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: mealNameLabel.font ?? UIFont.preferredFont(forTextStyle: .body)], context: nil)
        
        // Meal image view
        
        addSubview(mealImageView)
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mealImageView.topAnchor.constraint(equalTo: topAnchor),
            mealImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Bottom blur effect
        
        let bottomEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        bottomEffect.translatesAutoresizingMaskIntoConstraints = false
        bottomEffect.clipsToBounds = true
        addSubview(bottomEffect)
        
        NSLayoutConstraint.activate([
            bottomEffect.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomEffect.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomEffect.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomEffect.heightAnchor.constraint(equalToConstant: areaBoundingBox.height + nameBoundingBox.height + 8 + 3 * 8)
        ])
        
        // Meal area blur effect + label
        
        let areaEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        areaEffect.translatesAutoresizingMaskIntoConstraints = false
        areaEffect.clipsToBounds = true
        areaEffect.layer.cornerRadius = (areaBoundingBox.height + 8) / 2
        
        addSubview(areaEffect)
        
        areaEffect.contentView.addSubview(mealAreaLabel)
        mealAreaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealAreaLabel.leadingAnchor.constraint(equalTo: mealAreaLabel.superview!.leadingAnchor, constant: 12),
            mealAreaLabel.trailingAnchor.constraint(equalTo: mealAreaLabel.superview!.trailingAnchor, constant: -12),
            mealAreaLabel.topAnchor.constraint(equalTo: mealAreaLabel.superview!.topAnchor, constant: 4),
            mealAreaLabel.bottomAnchor.constraint(equalTo: mealAreaLabel.superview!.bottomAnchor, constant: -4),
        ])
        
        NSLayoutConstraint.activate([
            areaEffect.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            areaEffect.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
        
        // Meal category blue effect + label
        
        let categoryEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        categoryEffect.translatesAutoresizingMaskIntoConstraints = false
        categoryEffect.clipsToBounds = true
        categoryEffect.layer.cornerRadius = (areaBoundingBox.height + 8) / 2
        
        addSubview(categoryEffect)
        
        categoryEffect.contentView.addSubview(mealCategoryLabel)
        mealCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealCategoryLabel.leadingAnchor.constraint(equalTo: mealCategoryLabel.superview!.leadingAnchor, constant: 12),
            mealCategoryLabel.trailingAnchor.constraint(equalTo: mealCategoryLabel.superview!.trailingAnchor, constant: -12),
            mealCategoryLabel.topAnchor.constraint(equalTo: mealCategoryLabel.superview!.topAnchor, constant: 4),
            mealCategoryLabel.bottomAnchor.constraint(equalTo: mealCategoryLabel.superview!.bottomAnchor, constant: -4),
        ])
        
        NSLayoutConstraint.activate([
            categoryEffect.leadingAnchor.constraint(equalTo: areaEffect.trailingAnchor, constant: 8),
            categoryEffect.bottomAnchor.constraint(equalTo: areaEffect.bottomAnchor)
        ])
        
        // Meal name label
        
        addSubview(mealNameLabel)
        mealNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mealNameLabel.bottomAnchor.constraint(equalTo: areaEffect.topAnchor, constant: -8),
            mealNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
