//
//  MealInfoViewController.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 20.09.2021.
//

import UIKit

public class MealInfoViewController: UICollectionViewController {
    // MARK: - Properties
    
    /// ID of the current meal. This property is used to request full meal information if it was not available at the time of initialization
    private var mealID: String
    /// Full information about the current meal. If this property is still `nil` at the time of initialization, a network request is made to get meal info from by its ID.
    private var mealInfo: FullMealInfo!
    /// View models for collection view sections
    private var models: [BaseSectionViewModel] = []
    
    // MARK: - Initializers
    
    public init(mealID: String) {
        self.mealID = mealID
        super.init(collectionViewLayout: Self.createLayout())
    }
    
    public init(mealInfo: FullMealInfo){
        self.mealID = mealInfo.mealID
        self.mealInfo = mealInfo
        super.init(collectionViewLayout: Self.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = NSLocalizedString("recipe_title", comment: "")
        
        // Registering cells and supplementary views
        collectionView.register(QuickMealInfoCell.self, forCellWithReuseIdentifier: QuickMealInfoCell.reuseIdentifier)
        
        // Requesting meal info if necessary
        if mealInfo != nil {
            update()
        } else {
            MealByIDRequest(mealID: mealID).send { result in
                switch result {
                case .success(let mealByIDResponse):
                    self.mealInfo = mealByIDResponse.mealInfo
                case .failure(let error):
                    print(error)
                }
                
                if self.mealInfo == nil {
                    // If we were not able to get meal info, remove this controller from stack
                    self.navigationController?.popViewController(animated: true)
                } else {
                    // Otherwise, update collection view
                    self.update()
                }
            }
        }
    }
    
    // MARK: - Updates
    
    private func update() {
        let quickInfoSection = BaseSectionViewModel(uniqueSectionName: "QuickInfoSection")
        models.append(quickInfoSection)
        quickInfoSection.items.append(QuickMealInfoItemViewModel(mealInfo: mealInfo))
    }
    
    // MARK: - Collection View Layout
    
    private static func createLayout() -> UICollectionViewCompositionalLayout {
        return .init { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120 + 8 * 2))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                return section
            default:
                return nil
            }
        }
    }
    
    // MARK: - Collection View Data Source
    
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
