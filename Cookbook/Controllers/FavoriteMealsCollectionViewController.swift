//
//  FavoriteMealsCollectionViewController.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 27.09.2021.
//

import UIKit

/// View controller responsible for displaying user's favorite meals
public class FavoriteMealsCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    /// Section view models
    private var models: [BaseSectionViewModel] = []
    
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
        var oldModels: [ShortMealInfoItemViewModel] = []
        
        if !models.isEmpty,
           let oldMealsSection = models.first,
           let oldMealItems = oldMealsSection.items as? [ShortMealInfoItemViewModel] {
            oldModels = oldMealItems
        }
        
        models.removeAll()
        
        let mealsSection = BaseSectionViewModel(uniqueSectionName: "MealsSection")
        models.append(mealsSection)
        
        for meal in UserSettings.shared.favoriteMeals {
            if let index = oldModels.firstIndex(where: { $0.mealInfo.mealID == meal.mealID }) {
                mealsSection.items.append(oldModels[index])
            } else {
                mealsSection.items.append(ShortMealInfoItemViewModel(mealInfo: ShortMealInfo(mealID: meal.mealID, mealName: meal.mealName, imageURL: meal.imageURL)))
            }
        }

        collectionView.reloadData()
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
    
    // MARK: - Responding to user actions
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mealInfoViewController = MealInfoViewController(mealInfo: UserSettings.shared.favoriteMeals[indexPath.item])
        navigationController?.pushViewController(mealInfoViewController, animated: true)
    }
}
