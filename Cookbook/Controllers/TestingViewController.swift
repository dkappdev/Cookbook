//
//  TestingViewController.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 13.09.2021.
//

import UIKit

/// This controller is used exclusively for development purposes when designing `UIView`s. It will be deleted later
public class TestingViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let sectionName = NamedSectionHeader()
        view.addSubview(sectionName)
        sectionName.translatesAutoresizingMaskIntoConstraints = false
        
        sectionName.nameLabel.text = "Meal of the Day"
        
        NSLayoutConstraint.activate([
            sectionName.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sectionName.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sectionName.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
        
        let subview = MealOfTheDayCell()
        view.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        RandomMealRequest().send { result in
            switch result {
            case .success(let randomMealResponse):
                ArbitraryImageRequest(imageURL: randomMealResponse.mealInfo.imageURL).send { result in
                    switch result {
                    case .success(let image):
                        DispatchQueue.main.async {                            
                            subview.mealImageView.image = image
                            let mealInfo = randomMealResponse.mealInfo
                            subview.mealNameLabel.text = mealInfo.mealName
                            subview.mealAreaLabel.text = mealInfo.areaInfo.prettyString
                            subview.mealCategoryLabel.text = mealInfo.category
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            subview.topAnchor.constraint(equalTo: sectionName.bottomAnchor, constant: 16),
            subview.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
}
