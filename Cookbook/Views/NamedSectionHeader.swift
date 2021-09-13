//
//  NamedSectionHeader.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 13.09.2021.
//

import UIKit

public class NamedSectionHeader: UICollectionReusableView {
    // MARK: - Views
    
    public let nameLabel: UILabel = {
        let label = UILabel()
        let staticFont = UIFont.systemFont(ofSize: 28, weight: .semibold)
        let dynamicFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: staticFont)
        label.font = dynamicFont
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    // MARK: - Static properties
    
    public static let reuseIdentifier = "SectionHeader"
    public static let elementKind = UICollectionView.elementKindSectionHeader
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    // MARK: Layout setup
    
    private func setupLayout() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
