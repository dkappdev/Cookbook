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
    
    // MARK: - Initializers
    
    public init(mealInfo: FullMealInfo) {
        self.mealInfo = mealInfo
    }
    
    // MARK: - Setup
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? CookingInstructionsCell else { return }
        
        // Setting up label
        cell.cookingInstructionsLabel.text = mealInfo.cookingInstructions
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(mealInfo)
    }
}

public func == (lhs: CookingInstructionsItemViewModel, rhs: CookingInstructionsItemViewModel) -> Bool {
    lhs.mealInfo == rhs.mealInfo
}
