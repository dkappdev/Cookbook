//
//  BaseSectionViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 13.09.2021.
//

import UIKit

public class BaseSectionViewModel: SectionViewModel, Hashable {
    public let sectionUniqueName: String
    
    public var headerItem: BaseItemViewModel? = nil
    
    public var footerItem: BaseItemViewModel? = nil
    
    public var items: [BaseItemViewModel] = []
    
    public init(sectionUniqueName: String) {
        self.sectionUniqueName = sectionUniqueName
    }
    
    public func hash(into hasher: inout Hasher) {
        fatalError("hash(into:) for ItemViewModel has not been implemented")
    }
}

public func == (lhs: BaseSectionViewModel, rhs: BaseSectionViewModel) -> Bool {
    return lhs.sectionUniqueName == rhs.sectionUniqueName
}
