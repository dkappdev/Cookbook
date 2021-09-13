//
//  HomeCollectionViewController.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 12.09.2021.
//

import UIKit

/// View controller that display the home screen of the app. This screen contains meal of the day, list of meal categories and areas.
public class HomeCollectionViewController: UICollectionViewController {
    
    public let models: [SectionViewModel] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        
        // Setting up meal of the day section with empty info
        let mealOfTheDaySection = MealOfTheDaySectionViewModel()
        mealOfTheDaySection.headerItem = NamedSectionItemViewModel(sectionName: NSLocalizedString("meal_of_the_day_section_name", comment: ""))
        mealOfTheDaySection.items.append(MealOfTheDayItemViewModel(mealInfo: FullMealInfo.empty, mealImage: UIImage()))
        
        // Starting network request to get actual information
        RandomMealRequest().send { result in
            switch result {
            case .success(let randomMealResponse):
                ArbitraryImageRequest(imageURL: randomMealResponse.mealInfo.imageURL).send { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let image):
                        mealOfTheDaySection.items[0] = MealOfTheDayItemViewModel(mealInfo: randomMealResponse.mealInfo, mealImage: image)
                        DispatchQueue.main.async {
                            self.updateCollectionView()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Creates diffable data source for collection view
    private func createDataSource() {
//        let dataSource = UICollectionView
    }
    
    private func updateCollectionView() {
        
    }
}
