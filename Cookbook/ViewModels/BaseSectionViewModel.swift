//
//  BaseSectionViewModel.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 13.09.2021.
//

import UIKit

public class BaseSectionViewModel: SectionViewModel, Hashable {
    public let uniqueSectionName: String
    
    public var headerItem: BaseItemViewModel? = nil
    
    public var footerItem: BaseItemViewModel? = nil
    
    public var items: [BaseItemViewModel] = []
    
    public init(uniqueSectionName: String) {
        self.uniqueSectionName = uniqueSectionName
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueSectionName)
    }
}

public func == (lhs: BaseSectionViewModel, rhs: BaseSectionViewModel) -> Bool {
    return lhs.uniqueSectionName == rhs.uniqueSectionName
}
