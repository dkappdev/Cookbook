//
//  ImageViewController.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 25.09.2021.
//

import UIKit

public protocol ImageViewControllerDelegate: AnyObject {
    func imageViewControllerDidDismiss(_ imageViewController: ImageViewController)
}

/// View Controllers that displays a single image at the center of the screen
public class ImageViewController: UIViewController {
    
    // MARK: - Views
    
    private let doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonTapped))
        button.tintColor = .white
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isAccessibilityElement = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Properties
    
    public var image: UIImage
    public weak var delegate: ImageViewControllerDelegate?
    
    // MARK: - Initializers
    
    /// Creates a new image view controller that displays specified image
    /// - Parameter image: image do display
    public init(with image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    public override func viewDidLoad() {
        view.backgroundColor = .black
        
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        imageView.image = image
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func doneBarButtonTapped() {
        delegate?.imageViewControllerDidDismiss(self)
    }
}
