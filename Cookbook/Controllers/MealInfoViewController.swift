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
    
    /// Creates VC to display information for meal with specified ID. This initializer requests meal information from network. It should only be used if you don't have access to full meal information. Otherwise, use `init(mealInfo:)` to avoid creating a delay.
    /// - Parameter mealID: meal ID
    public init(mealID: String) {
        self.mealID = mealID
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    /// Creates VC that displays meal information passed as an argument
    /// - Parameter mealInfo: meal information
    public init(mealInfo: FullMealInfo) {
        self.mealID = mealInfo.mealID
        self.mealInfo = mealInfo
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        
        // Setting up navigation item
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = NSLocalizedString("recipe_title", comment: "")
        
        // Registering cells and supplementary views
        collectionView.register(MealInfoSummaryInfoCell.self, forCellWithReuseIdentifier: MealInfoSummaryInfoCell.reuseIdentifier)
        collectionView.register(IngredientAmountCell.self, forCellWithReuseIdentifier: IngredientAmountCell.reuseIdentifier)
        collectionView.register(CookingInstructionsCell.self, forCellWithReuseIdentifier: CookingInstructionsCell.reuseIdentifier)
        collectionView.register(NamedSectionHeader.self, forSupplementaryViewOfKind: NamedSectionHeader.elementKind, withReuseIdentifier: NamedSectionHeader.reuseIdentifier)
        
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
                
                DispatchQueue.main.async {
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
        
        // Disabling collection view prefetching
        // (See `HomeCollectionViewController.viewDidLoad()` for more information)
        collectionView.isPrefetchingEnabled = false
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
    }
    
    // MARK: - Updates
    
    /// Creates collection view sections with meal information
    private func update() {
        models.removeAll()
        
        // Quick meal info
        
        let mealInfoSummarySection = BaseSectionViewModel(uniqueSectionName: "QuickInfoSection")
        models.append(mealInfoSummarySection)
        let mealInfoSummaryItem = MealInfoSummaryItemViewModel(mealInfo: mealInfo)
        mealInfoSummarySection.items.append(mealInfoSummaryItem)
        mealInfoSummaryItem.setOpenImageAction { [weak self] image in
            guard let self = self else { return }
            self.openMealImage(image: image)
        }
        mealInfoSummaryItem.setToggleFavoriteAction { [weak self] mealInfo in
            guard let self = self else { return }
            self.toggleFavorite(meal: mealInfo)
        }
        
        // Ingredients
        
        let ingredientsSection = BaseSectionViewModel(uniqueSectionName: "IngredientsSection")
        models.append(ingredientsSection)
        ingredientsSection.headerItem = NamedSectionItemViewModel(sectionName: NSLocalizedString("ingredients_section_name", comment: ""))
        for ingredient in mealInfo.ingredients {
            let ingredientModel = IngredientAmountItemViewModel(ingredientAmount: ingredient)
            ingredientsSection.items.append(ingredientModel)
            ingredientModel.setOpenImageAction { [weak self] image in
                guard let self = self else { return }
                self.openMealImage(image: image)
            }
        }
        
        // Cooking instructions
        
        let cookingInstructionsSection = BaseSectionViewModel(uniqueSectionName: "CookingInstructionsSection")
        models.append(cookingInstructionsSection)
        cookingInstructionsSection.headerItem = NamedSectionItemViewModel(sectionName: NSLocalizedString("cooking_instructions_section_name", comment: ""))
        let cookingInstructionsItem = CookingInstructionsItemViewModel(mealInfo: mealInfo)
        cookingInstructionsSection.items.append(cookingInstructionsItem)
        cookingInstructionsItem.setYouTubeButtonAction { [weak self] in
            guard let self = self else { return }
            self.openRecipeInYouTube()
        }
        
        // Reloading data to show new sections
        collectionView.reloadData()
    }
    
    // MARK: - Collection View Layout
    
    /// Creates custom collection view layout
    /// - Returns: new layout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return .init { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(max(MealInfoSummaryInfoCell.imageSize, MealInfoSummaryInfoCell.textHeight)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                return section
            case 1:
                let itemsSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemsSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(160))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                section.interGroupSpacing = 16
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                var sectionHeight: CGFloat = 0
                if self.mealInfo.youtubeURL != nil {
                    // Button height
                    sectionHeight += 2 * 16 + UILabel.labelHeight(for: .preferredFont(forTextStyle: .body))
                    // Distance between button and label
                    sectionHeight += 16
                }
                // Label height
                sectionHeight += UILabel.labelHeight(for: .preferredFont(forTextStyle: .body), withText: self.mealInfo.cookingInstructions, width: self.collectionView.bounds.width - 16 * 2)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(sectionHeight))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
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
    
    // MARK: - Responding to user actions
    
    private func openRecipeInYouTube() {
        if let youtubeURL = mealInfo.youtubeURL {
            UIApplication.shared.open(youtubeURL)
        }
    }
    
    private func openMealImage(image: UIImage) {
        let imageViewController = ImageViewController(image: image)
        imageViewController.delegate = self
        imageViewController.modalPresentationStyle = .fullScreen
        present(imageViewController, animated: true, completion: nil)
    }
    
    private func toggleFavorite(meal: FullMealInfo) {
        UserSettings.shared.toggleFavorite(for: meal)
    }
}

// MARK: - Image VC delegate

extension MealInfoViewController: ImageViewControllerDelegate {
    public func imageViewControllerDidDismiss(_ imageViewController: ImageViewController) {
        // Dismiss image VC that was presented modally
        self.dismiss(animated: true, completion: nil)
    }
}
