//
//  ResultCollectionViewController.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 01.10.2021.
//

import UIKit

/// View controller responsible for displaying search results
public class ResultCollectionViewController: UICollectionViewController {
    
    public typealias DataSourceType = UICollectionViewDiffableDataSource<BaseSectionViewModel, BaseItemViewModel>
    
    // MARK: - Properties
    
    /// Section view models
    private var models: [BaseSectionViewModel] = []
    
    /// Collection view diffable data source
    private var dataSource: DataSourceType!
    
    /// View controller that presented this results controller. It is used to access its navigation controller
    private var searchViewController: SearchCollectionViewController
    
    // MARK: - Initializers
    
    public init(searchViewController: SearchCollectionViewController) {
        self.searchViewController = searchViewController
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
        navigationItem.largeTitleDisplayMode = .never
        
        collectionView.register(ShortMealInfoCell.self, forCellWithReuseIdentifier: ShortMealInfoCell.reuseIdentifier)
        
        // Creating data source
        dataSource = createDataSource()
    }
    
    // MARK: - Updates
    
    public func requestResults(matchingName name: String?) {
        Self.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(fetchMeals(withName:)), with: name, afterDelay: 0.5)
    }
    
    /// Fetches meals that match specified name from network
    @objc public func fetchMeals(withName name: String?) {
        
        print("performed with name \(name as Any)")
        
        let mealName = name ?? ""
        
        models.removeAll()
        
        let mealsSection = BaseSectionViewModel(uniqueSectionName: "MealsSection")
        models.append(mealsSection)
        
        // If search term is empty, remove all displayed meals
        guard !mealName.isEmpty else {
            updateCollectionView()
            return
        }
        
        MealsByNameRequest(mealName: mealName).send { result in
            switch result {
            case .success(let mealsByNameResponse):
                mealsSection.items.removeAll()
                
                guard let meals = mealsByNameResponse.mealInfos else {
                    // If no meals were found, remove all results from collection view
                    DispatchQueue.main.async {
                        self.updateCollectionView()
                    }
                    break
                }
                
                for meal in meals {
                    mealsSection.items.append(ShortMealInfoItemViewModel(mealInfo: ShortMealInfo(mealID: meal.mealID, mealName: meal.mealName, imageURL: meal.imageURL)))
                }
                
                DispatchQueue.main.async {
                    self.updateCollectionView()
                }
            case .failure(let error):
                print(error)
            }
        }
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
        guard let mealOfTheDayViewModel = models[indexPath.section].items[indexPath.item] as? ShortMealInfoItemViewModel else { return }
        let mealInfoViewController = MealInfoViewController(mealID: mealOfTheDayViewModel.mealInfo.mealID)
        searchViewController.navigationController?.pushViewController(mealInfoViewController, animated: true)
    }
}
