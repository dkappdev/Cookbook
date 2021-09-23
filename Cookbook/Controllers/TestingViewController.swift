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
        
        let quickMealInfoView = QuickMealInfoCell()
        quickMealInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(quickMealInfoView)
        
        quickMealInfoView.mealImageView.image = UIImage(systemName: "star.fill")
        quickMealInfoView.mealNameLabel.text = "Pommes"
        
        NSLayoutConstraint.activate([
            quickMealInfoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            quickMealInfoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            quickMealInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            quickMealInfoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        quickMealInfoView.mealAreaLabel.text = "🇫🇷 French"
        quickMealInfoView.mealCategoryLabel.text = "Vegan"
    }
}
