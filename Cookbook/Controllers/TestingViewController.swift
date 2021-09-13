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
        
        let subview = MealOfTheDayCell()
        
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
        
        view.addSubview(subview)
        
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            subview.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            subview.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
}
