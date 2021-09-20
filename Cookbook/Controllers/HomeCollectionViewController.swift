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
    
    public var models: [BaseSectionViewModel] = []
    
    public var dataSource: DataSourceType!
    
    // MARK: - View Lifecycle
    
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
        
        // Creating layout and data source
        dataSource = createDataSource()
        collectionView.collectionViewLayout = createLayout()
        
        // Having prefetching enabled and using orthogonal scrolling causes collection view to dequeue cells too many times
        // (Each cell gets dequeued around 20-30 times)
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
        // MARK: Meal of the Day section
        
        // Setting up meal of the day section with empty info
        let mealOfTheDaySection = BaseSectionViewModel(uniqueSectionName: "MealOfTheDaySection")
        models.append(mealOfTheDaySection)
        
        mealOfTheDaySection.headerItem = NamedSectionItemViewModel(sectionName: NSLocalizedString("meal_of_the_day_section_name", comment: ""))
        mealOfTheDaySection.items.append(MealOfTheDayItemViewModel(mealInfo: FullMealInfo.empty))
        
        // Starting network request to get actual information
        RandomMealRequest().send { result in
            switch result {
            case .success(let randomMealResponse):
                mealOfTheDaySection.items.removeAll()
                mealOfTheDaySection.items.append(MealOfTheDayItemViewModel(mealInfo: randomMealResponse.mealInfo))
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
                
                if let unknownIndex = areas.firstIndex(where: { $0.name == "Unknown" }) {
                    let unknown = areas.remove(at: unknownIndex)
                    areas.append(unknown)
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
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return .init { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }
            switch sectionIndex {
            // Meal of the day section
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(350))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(self.labelHeight(for: NamedSectionHeader().nameLabel.font) + 8 + 12))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
            // Meals by category sections
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16)
                section.interGroupSpacing = 16
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(self.labelHeight(for: NamedSectionHeader().nameLabel.font) + 8 + 12))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(self.labelHeight(for: NamedSectionHeader().nameLabel.font) + 8 + 12))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
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
        let dataSource = DataSourceType(collectionView: collectionView) { [weak self] collectionView, indexPath, model in
            guard let self = self else { return nil }
            let model = self.models[indexPath.section].items[indexPath.row]
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
    
    // MARK: - Utility methods
    
    private func labelHeight(for font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude)
        let areaBoundingBox = "Label".boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return areaBoundingBox.height
    }
    
}
