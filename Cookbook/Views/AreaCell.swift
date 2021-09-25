//
//  AreaCell.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 20.09.2021.
//

import UIKit

/// Collection view cell that displays a meal area
public class AreaCell: UICollectionViewCell {
    
    // MARK: - Views
    
    public let flagLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        return label
    }()
    
    public let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        return label
    }()
    
    public let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .tertiaryLabel
        line.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        line.isAccessibilityElement = false
        return line
    }()
    
    // MARK: - Static properties
    
    public static let reuseIdentifier = "Area Cell"
    
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
    
    private func setupLayout() {
        
        isAccessibilityElement = true
        
        addSubview(flagLabel)
        flagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        flagLabel.setContentHuggingPriority(UILayoutPriority(751), for: .horizontal)
        
        NSLayoutConstraint.activate([
            flagLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            flagLabel.topAnchor.constraint(equalTo: topAnchor),
            flagLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: flagLabel.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: flagLabel.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
}
