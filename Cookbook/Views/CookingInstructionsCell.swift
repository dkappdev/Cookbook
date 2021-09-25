//
//  CookingInstructionsCell.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 25.09.2021.
//

import UIKit

public class CookingInstructionsCell: UICollectionViewCell {
    // MARK: - Views
    
    public let cookingInstructionsLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    public let openInYouTubeButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("open_in_youtube_button_label", comment: ""), for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        #warning("Make sure VoiceOver reads this button correctly")
        return button
    }()
    
    // MARK: - Static properties
    
    public static let reuseIdentifier = "CookingInstructionsCell"
    
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
        // Cooking instructions label
        
        addSubview(cookingInstructionsLabel)
        cookingInstructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cookingInstructionsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            cookingInstructionsLabel.topAnchor.constraint(equalTo: topAnchor),
            cookingInstructionsLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // "Open in YouTube" button
        
        addSubview(openInYouTubeButton)
        openInYouTubeButton.translatesAutoresizingMaskIntoConstraints = false
        
        openInYouTubeButton.layer.masksToBounds = true
        openInYouTubeButton.layer.cornerRadius = 12
        
        NSLayoutConstraint.activate([
            openInYouTubeButton.topAnchor.constraint(equalTo: cookingInstructionsLabel.bottomAnchor, constant: 16),
            openInYouTubeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            openInYouTubeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            // Make sure button can fit label with additional vertical padding
            openInYouTubeButton.heightAnchor.constraint(equalToConstant: UILabel.labelHeight(for: .preferredFont(forTextStyle: .body)) + 2 * 16),
        ])
    }
}
