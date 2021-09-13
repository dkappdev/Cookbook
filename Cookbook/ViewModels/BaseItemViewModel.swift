//
//  BaseItemViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 13.09.2021.
//

import UIKit

public class BaseItemViewModel: ItemViewModel, Hashable {
    public var reuseIdentifier: String {
        fatalError("reuseIdentifier for ItemViewModel has not been set")
    }
    
    public func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        fatalError("setup(:in:at:) for ItemViewModel has not been implemented")
    }
    
    public func hash(into hasher: inout Hasher) {
        fatalError("hash(into:) for ItemViewModel has not been implemented")
    }
}

// Conforming to Equatable
public func == (lhs: BaseItemViewModel, rhs: BaseItemViewModel) -> Bool {
    fatalError("equality operator for ItemViewModel has not been implemented")
}
