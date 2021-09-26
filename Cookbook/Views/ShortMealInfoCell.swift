//
//  ShortMealInfoCell.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 26.09.2021.
//

import UIKit

public class ShortMealInfoCell: UICollectionViewCell {
    
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
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Static properties
    
    public static let reuseIdentifier = "ShortMealInfoCell"
    
    // MARK: - Initializers
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
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
        
        // Creating shadow
        
        layer.cornerRadius = 12
        layer.shadowRadius = 6
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.masksToBounds = false
        
        // Container view
        // This container holds the image view and meal label
        // Using a separate container allows us to create rounded corners for cell while keeping the drop shadow
        
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
        
        // Meal image view
        
        containerView.addSubview(mealImageView)
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mealImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        // Bottom blur effect
        
        let bottomEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        bottomEffect.clipsToBounds = true
        
        containerView.addSubview(bottomEffect)
        bottomEffect.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomEffect.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            bottomEffect.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomEffect.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        // Meal name label
        
        containerView.addSubview(mealNameLabel)
        mealNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            mealNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8),
            mealNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // Finishing bottom blur effect
        
        NSLayoutConstraint.activate([
            bottomEffect.topAnchor.constraint(equalTo: mealNameLabel.topAnchor, constant: -8)
        ])
    }
}
