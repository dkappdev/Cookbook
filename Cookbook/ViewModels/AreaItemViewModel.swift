//
//  AreaItemViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 20.09.2021.
//

import UIKit

public class AreaItemViewModel: BaseItemViewModel {
    // MARK: - Properties
    
    public override var reuseIdentifier: String {
        AreaCell.reuseIdentifier
    }
    
    public let areaInfo: AreaInfo
    
    // MARK: - Initializers
    
    public init(areaInfo: AreaInfo) {
        self.areaInfo = areaInfo
    }
    
    // MARK: - Cell setup
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? AreaCell else { return }
        
        cell.flagLabel.text = areaInfo.flagEmoji
        cell.nameLabel.text = areaInfo.name
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(areaInfo.name)
    }
}

public func == (lhs: AreaItemViewModel, rhs: AreaItemViewModel) -> Bool {
    lhs.areaInfo.name == rhs.areaInfo.name
}
