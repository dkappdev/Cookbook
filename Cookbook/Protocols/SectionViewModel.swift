//
//  SectionViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 12.09.2021.
//

import UIKit

/// Set of properties and methods that collection view section view models should implement
public protocol SectionViewModel {
    
    /// Section header
    var headerItem: ItemViewModel? { get }
    
    /// Section footer
    var footerItem: ItemViewModel? { get }
    
    /// Section content items
    var items: [ItemViewModel] { get }
    
    /// Returns a supplementary view for the specified kind
    /// - Parameter elementKind: supplementary view kind
    /// - Returns: section's supplementary view of specifier kind
    func model(forElementOfKind elementKind: String) -> ItemViewModel?
}

extension SectionViewModel {
    public func model(forElementOfKind elementKind: String) -> ItemViewModel? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return headerItem
        case UICollectionView.elementKindSectionFooter:
            return footerItem
        default:
            return nil
        }
    }
}
