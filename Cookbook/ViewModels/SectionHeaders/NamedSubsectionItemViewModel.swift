//
//  NamedSubsectionItemViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 01.10.2021.
//

import UIKit

public class NamedSubsectionItemViewModel: BaseItemViewModel {
    
    // MARK: - Properties
    public override var reuseIdentifier: String {
        NamedSubsectionHeader.reuseIdentifier
    }
    
    public let sectionName: String
    
    // MARK: - Initializers
    
    public init(sectionName: String) {
        self.sectionName = sectionName
    }
    
    // MARK: - Setup
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? NamedSubsectionHeader else { return }
        
        cell.nameLabel.text = sectionName
        
        cell.accessibilityLabel = "\(sectionName)"
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(sectionName)
    }
}

// Conforming to Equatable
public func == (lhs: NamedSubsectionItemViewModel, rhs: NamedSubsectionItemViewModel) -> Bool {
    return lhs.sectionName == rhs.sectionName
}
