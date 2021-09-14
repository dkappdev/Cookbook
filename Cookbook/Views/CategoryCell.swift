//
//  CategoryCell.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 14.09.2021.
//

import UIKit

public class CategoryCell: UICollectionViewCell {
    
    // MARK: - Views
    
    public let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray4
        return imageView
    }()
    
    public let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    // MARK: - Static properties
    
    public static let reuseIdentifier = "CategoryCell"
    
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
        if let categoryName = categoryNameLabel.text {
            categoryImageView.accessibilityLabel = categoryName
        }
        
        // Category name label
                
        addSubview(categoryNameLabel)
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Category image view
        
        categoryImageView.layer.cornerRadius = 12
        categoryImageView.layer.masksToBounds = true
        
        addSubview(categoryImageView)
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryImageView.topAnchor.constraint(equalTo: topAnchor),
            categoryImageView.bottomAnchor.constraint(equalTo: categoryNameLabel.topAnchor, constant: -8)
        ])
    }
}
