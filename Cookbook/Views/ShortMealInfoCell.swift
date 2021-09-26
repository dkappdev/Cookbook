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
        
    }
}
