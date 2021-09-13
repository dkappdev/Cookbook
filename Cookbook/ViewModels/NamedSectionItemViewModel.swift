//
//  NamedSectionItemViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 13.09.2021.
//

import UIKit

public class NamedSectionItemViewModel: ItemViewModel {
    
    // MARK: - Properties
    public let reuseIdentifier: String = NamedSectionHeader.reuseIdentifier
    
    public let sectionName: String
    
    // MARK: - Initializers
    
    public init(sectionName: String) {
        self.sectionName = sectionName
    }
    
    // MARK: - Setup
    
    public func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? NamedSectionHeader else { return }
        
        cell.nameLabel.text = sectionName
    }
}
