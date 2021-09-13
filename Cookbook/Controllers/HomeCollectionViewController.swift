//
//  HomeCollectionViewController.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 12.09.2021.
//

import UIKit

/// View controller that display the home screen of the app. This screen contains meal of the day, list of meal categories and areas.
public class HomeCollectionViewController: UICollectionViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
    }
}
