//
//  HomeCollectionViewController.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 12.09.2021.
//

import UIKit

/// View controller that display the home screen of the app. This screen contains meal of the day, list of meal categories and areas.
public class HomeCollectionViewController: UICollectionViewController {
    
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
        
        // Configuring navigation controller
        navigationItem.title = NSLocalizedString("tab_bar_home_button_title", comment: "")
        
        // Registering cells and supplementary views
        collectionView.register(NamedSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NamedSectionHeader.reuseIdentifier)
        collectionView.register(MealOfTheDayCell.self, forCellWithReuseIdentifier: MealOfTheDayCell.reuseIdentifier)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        collectionView.register(AreaCell.self, forCellWithReuseIdentifier: AreaCell.reuseIdentifier)
        
        // Creating data source
        dataSource = createDataSource()
        
        // Having prefetching enabled and using orthogonal scrolling causes collection view to dequeue cells too many times
        // (Each cell gets dequeued around 10-20 times)
        // There doesn't seem to be any information about this issue on the internet
        // The only other solution I have come up with is to completely abandon orthogonal scrolling, but that would make the main screen too cluttered
        // Because of this, I disabled prefetching for now
        collectionView.isPrefetchingEnabled = false
        
        // Triggering update
        update()
    }
    
    // MARK: - Updates
    
    /// Updates model data with new information received from network
    private func update() {
        models.removeAll()
        
        // MARK: Meal of the Day section
        
        // Setting up meal of the day section with empty info
        let mealOfTheDaySection = BaseSectionViewModel(uniqueSectionName: "MealOfTheDaySection")
        models.append(mealOfTheDaySection)
        
        mealOfTheDaySection.headerItem = NamedSectionItemViewModel(sectionName: NSLocalizedString("meal_of_the_day_section_name", comment: ""))
        mealOfTheDaySection.items.append(MealOfTheDayItemViewModel(mealInfo: FullMealInfo.empty))
        
        // Getting meal of the day from user settings
        UserSettings.shared.mealOfTheDay { result in
            switch result {
            case .success(let mealInfo):
                mealOfTheDaySection.items.removeAll()
                mealOfTheDaySection.items.append(MealOfTheDayItemViewModel(mealInfo: mealInfo))
                DispatchQueue.main.async {
                    self.updateCollectionView()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        // MARK: Meals by Category section
        
        let mealsByCategorySection = BaseSectionViewModel(uniqueSectionName: "MealsByCategorySection")
        models.append(mealsByCategorySection)
        mealsByCategorySection.headerItem = NamedSectionItemViewModel(sectionName: NSLocalizedString("meals_by_category_section_name", comment: ""))
        for _ in 0..<3 {
            mealsByCategorySection.items.append(CategoryItemViewModel(categoryInfo: CategoryInfo.empty))
        }
        
        CategoryListRequest().send { result in
            switch result {
            case .success(let categoryListResponse):
                mealsByCategorySection.items.removeAll()
                var categories = categoryListResponse.categoryInfos.sorted { $0.categoryName < $1.categoryName }
                if let miscIndex = categories.firstIndex(where: { $0.categoryName == "Miscellaneous" }) {
                    let misc = categories.remove(at: miscIndex)
                    categories.append(misc)
                }
                for category in categories {
                    mealsByCategorySection.items.append(CategoryItemViewModel(categoryInfo: category))
                }
                DispatchQueue.main.async {
                    self.updateCollectionView()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        let mealsByAreaSection = BaseSectionViewModel(uniqueSectionName: "MealsByAreaSection")
        models.append(mealsByAreaSection)
        mealsByAreaSection.headerItem = NamedSectionItemViewModel(sectionName: NSLocalizedString("meals_by_area_section_name", comment: ""))
        
        AreaListRequest().send { result in
            switch result {
            case .success(let areaListResponse):
                var areas = areaListResponse.areaInfos.sorted { $0.name < $1.name }
                
                if let otherIndex = areas.firstIndex(where: { $0.name == "Other" }) {
                    let other = areas.remove(at: otherIndex)
                    areas.append(other)
                }
                
                for areaInfo in areas {
                    mealsByAreaSection.items.append(AreaItemViewModel(areaInfo: areaInfo))
                }
                DispatchQueue.main.async {
                    self.updateCollectionView()
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        // Starting first collection view update to display empty cells
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
        return .init { sectionIndex, environment in
            switch sectionIndex {
            // Meal of the day section
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(350))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
            // Meals by category sections
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(160))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16)
                section.interGroupSpacing = 16
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(UILabel.labelHeight(for: .preferredFont(forTextStyle: .title1)) + 8))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                
                section.boundarySupplementaryItems = [header]
                
                return section
            default:
                return nil
            }
        }
    }
    
    // MARK: - Collection view data source
    
    /// Creates diffable data source for collection view
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
        switch indexPath.section {
        case 0:
            guard let mealOfTheDayViewModel = models[indexPath.section].items[indexPath.item] as? MealOfTheDayItemViewModel else { return }
            let mealInfoViewController = MealInfoViewController(mealInfo: mealOfTheDayViewModel.mealInfo)
            navigationController?.pushViewController(mealInfoViewController, animated: true)
        case 1:
            guard let categoryViewModel = models[indexPath.section].items[indexPath.item] as? CategoryItemViewModel else { return }
            let mealsForCategoryViewController = MealsForCategoryCollectionViewController(categoryName: categoryViewModel.categoryInfo.categoryName)
            navigationController?.pushViewController(mealsForCategoryViewController, animated: true)
        case 2:
            guard let areaViewModel = models[indexPath.section].items[indexPath.item] as? AreaItemViewModel else { return }
            let mealsForAreaViewController = MealsForAreaCollectionViewController(areaName: areaViewModel.areaInfo.name)
            navigationController?.pushViewController(mealsForAreaViewController, animated: true)
        default:
            break
        }
    }
}
