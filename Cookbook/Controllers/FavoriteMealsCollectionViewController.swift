//
//  FavoriteMealsCollectionViewController.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 27.09.2021.
//

import UIKit

/// View controller responsible for displaying user's favorite meals
public class FavoriteMealsCollectionViewController: UICollectionViewController {
    
    public typealias DataSourceType = UICollectionViewDiffableDataSource<BaseSectionViewModel, BaseItemViewModel>
    
    // MARK: - Properties
    
    /// Section view models
    private var models: [BaseSectionViewModel] = []
    
    /// Collection view diffable data source
    private var dataSource: DataSourceType!
    
    // MARK: - Initializers
    
    public init() {
        super.init(collectionViewLayout: Self.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting background color
        collectionView.backgroundColor = .systemBackground
        
        // Configuring navigation controller title
        // We're not using localized string here because area names are not localized
        navigationItem.title = NSLocalizedString("favorite_meals_header", comment: "")
        
        collectionView.register(ShortMealInfoCell.self, forCellWithReuseIdentifier: ShortMealInfoCell.reuseIdentifier)
        
        // Creating data source
        dataSource = createDataSource()
        
        // Triggering update
        
        update()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    // MARK: - Updates
    
    /// Updates model data with new data received from network
    private func update() {
        models.removeAll()
        
        let mealsSection = BaseSectionViewModel(uniqueSectionName: "MealsSection")
        models.append(mealsSection)
        
        for meal in UserSettings.shared.favoriteMeals {
            mealsSection.items.append(ShortMealInfoItemViewModel(mealInfo: ShortMealInfo(mealID: meal.mealID, mealName: meal.mealName, imageURL: meal.imageURL)))
        }

        updateCollectionView()
    }
    
    /// Updates collection view data source
    private func updateCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<BaseSectionViewModel, BaseItemViewModel>()
        
        for model in models {
            snapshot.appendSections([model])
            snapshot.appendItems(model.items, toSection: model)
            snapshot.reloadItems(model.items)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Collection view layout
    
    /// Creates custom collection view layout
    /// - Returns: new layout
    private static func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 16
        
        return .init(section: section)
    }
    
    // MARK: - Collection view data source
    
    /// Creates diffable data source
    /// - Returns: data source
    private func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, model in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.reuseIdentifier, for: indexPath)
            
            model.setup(cell, in: collectionView, at: indexPath)
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            
            guard let model = self.models[indexPath.section].model(forElementOfKind: kind) else { return nil }
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: model.reuseIdentifier, for: indexPath)
            model.setup(view, in: collectionView, at: indexPath)
            
            return view
        }
        
        return dataSource
    }
    
    // MARK: - Responding to user actions
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mealInfoViewController = MealInfoViewController(mealInfo: UserSettings.shared.favoriteMeals[indexPath.item])
        navigationController?.pushViewController(mealInfoViewController, animated: true)
    }
}
