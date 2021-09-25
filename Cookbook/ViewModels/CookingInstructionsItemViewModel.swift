//
//  CookingInstructionsItemViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 25.09.2021.
//

import UIKit

public class CookingInstructionsItemViewModel: BaseItemViewModel {
    // MARK: - Properties
    
    public override var reuseIdentifier: String {
        CookingInstructionsCell.reuseIdentifier
    }
    
    public let mealInfo: FullMealInfo
    private var openInYouTubeAction: (() -> Void)? = nil
    
    // MARK: - Initializers
    
    public init(mealInfo: FullMealInfo) {
        self.mealInfo = mealInfo
    }
    
    // MARK: - Setup
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? CookingInstructionsCell else { return }
        
        // Removing all previous actions for YouTube button because cell might be reused
        cell.openInYouTubeButton.removeTarget(nil, action: nil, for: .allEvents)
        
        // Adding action
        cell.openInYouTubeButton.addTarget(self, action: #selector(openInYouTube), for: .touchUpInside)
        
        // Setting up label
        cell.cookingInstructionsLabel.text = mealInfo.cookingInstructions
        
        if mealInfo.youtubeURL == nil {
            cell.openInYouTubeButton.isHidden = true
        }
    }
    
    public func setYouTubeButtonAction(_ action: @escaping () -> Void) {
        openInYouTubeAction = action
    }
    
    @objc private func openInYouTube() {
        openInYouTubeAction?()
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(mealInfo)
    }
}

public func == (lhs: CookingInstructionsItemViewModel, rhs: CookingInstructionsItemViewModel) -> Bool {
    lhs.mealInfo == rhs.mealInfo
}
