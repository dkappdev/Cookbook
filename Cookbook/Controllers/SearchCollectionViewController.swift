//
//  SearchCollectionViewController.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 01.10.2021.
//

import UIKit

public class SearchCollectionViewController: UIViewController {
    
    // MARK: - View Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up background and title
        
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("search_meals_header", comment: "")
        
        // Setting up search controller
        
        let resultController = ResultCollectionViewController()
        let searchController = UISearchController(searchResultsController: resultController)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = NSLocalizedString("search_meals_search_bar_placeholder", comment: "")
        
        // Setting up navigation item
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - Search results updating

extension SearchCollectionViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        // Trimming whitespace
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchController.searchBar.text?.trimmingCharacters(in: whitespaceCharacterSet)
        
        // Performing search
        if let resultController = searchController.searchResultsController as? ResultCollectionViewController {
            resultController.fetchMeals(withName: strippedString)
        }
    }
}

