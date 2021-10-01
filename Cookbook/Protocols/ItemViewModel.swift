//
//  ItemViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 11.09.2021.
//

import UIKit

/// Set of properties and methods that item view models should implement
public protocol ItemViewModel {

    /// Collection view cell reuse identifier
    var reuseIdentifier: String { get }
    
    /// Sets up collection view cell to display data
    /// - Parameters:
    ///   - cell: cell that needs to be set up
    ///   - collectionView: collection view that owns the cell
    ///   - indexPath: cell index path
    func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath)
}
