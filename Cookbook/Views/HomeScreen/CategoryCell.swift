//
//  CategoryCell.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 14.09.2021.
//

import UIKit

/// Collection view cell that displays a meal category
public class CategoryCell: UICollectionViewCell {
    
    // MARK: - Views
    
    public let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray4
        imageView.isAccessibilityElement = false
        return imageView
    }()
    
    public let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        return label
    }()
    
    // MARK: - Static properties
    
    public static let reuseIdentifier = "CategoryCell"
    
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
        isAccessibilityElement = true
        
        // Category name label
        
        addSubview(categoryNameLabel)
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Category image view
        
        let containerView = UIView()
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: categoryNameLabel.topAnchor, constant: -8)
        ])
        
        containerView.layer.masksToBounds = false
        containerView.layer.shadowRadius = 6
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        categoryImageView.layer.cornerRadius = 12
        categoryImageView.layer.masksToBounds = true
        
        containerView.addSubview(categoryImageView)
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            categoryImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            categoryImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            categoryImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}
