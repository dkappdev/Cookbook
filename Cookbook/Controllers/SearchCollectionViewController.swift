//
//  SearchCollectionViewController.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 01.10.2021.
//

import UIKit

public class SearchCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var models: [BaseSectionViewModel] = []
    
    // MARK: - Initializers
    
    public init() {
        super.init(collectionViewLayout: Self.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Registering views
        
        collectionView.register(NamedSubsectionHeader.self, forSupplementaryViewOfKind: NamedSubsectionHeader.elementKind, withReuseIdentifier: NamedSubsectionHeader.reuseIdentifier)
        collectionView.register(ShortMealInfoCell.self, forCellWithReuseIdentifier: ShortMealInfoCell.reuseIdentifier)
        
        // Setting up background and title
        
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("search_meals_header", comment: "")
        
        // Setting up search controller
        
        let resultController = ResultCollectionViewController(searchViewController: self)
        let searchController = UISearchController(searchResultsController: resultController)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = NSLocalizedString("search_meals_search_bar_placeholder", comment: "")
        
        // Setting up navigation item
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Updating recents
        
        update()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        update()
    }
    
    // MARK: - Updates
    
    private func update() {
        // Removing all models before updating
        models.removeAll()
        
        guard UserSettings.shared.recentMeals.count != 0 else { return }
        
        let recentSection = BaseSectionViewModel(uniqueSectionName: "Recent")
        models.append(recentSection)
        recentSection.headerItem = NamedSubsectionItemViewModel(sectionName: NSLocalizedString("recent_section_name", comment: ""))
        
        let reversedRecents = UserSettings.shared.recentMeals.reversed()
        
        for recent in reversedRecents {
            recentSection.items.append(ShortMealInfoItemViewModel(mealInfo: recent))
        }
        
        collectionView.reloadData()
    }
    
    private static func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 16
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        section.boundarySupplementaryItems = [header]
        
        return .init(section: section)
    }
    
    // MARK: - Collection view data source
    
    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        models.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models[section].items.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.section].items[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.reuseIdentifier, for: indexPath)
        model.setup(cell, in: collectionView, at: indexPath)
        
        return cell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let model = models[indexPath.section].model(forElementOfKind: kind) else { return UICollectionReusableView() }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: model.reuseIdentifier, for: indexPath)
        model.setup(view, in: collectionView, at: indexPath)
        
        return view
    }
}

// MARK: - Search results updating

extension SearchCollectionViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        // Trimming whitespace
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchController.searchBar.text?.trimmingCharacters(in: whitespaceCharacterSet)
        
        // Performing search
        if let resultController = searchController.searchResultsController as? ResultCollectionViewController {
            resultController.requestResults(matchingName: strippedString)
        }
    }
}

