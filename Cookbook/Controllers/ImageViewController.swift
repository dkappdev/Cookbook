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
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("done_bar_button_title", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
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
    public init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    /// Sets proper status bar color for light mode
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    public override func viewDidLoad() {
        view.backgroundColor = .black
        
        // Image view
        
        imageView.image = image
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // 'Done' button
        
        let buttonBackground = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
        view.addSubview(buttonBackground)
        buttonBackground.translatesAutoresizingMaskIntoConstraints = false
        buttonBackground.clipsToBounds = true
        
        buttonBackground.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            buttonBackground.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
        
        buttonBackground.contentView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: buttonBackground.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: buttonBackground.trailingAnchor, constant: -16),
            doneButton.topAnchor.constraint(equalTo: buttonBackground.topAnchor, constant: 8),
            doneButton.bottomAnchor.constraint(equalTo: buttonBackground.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Responding to user actions
    
    @objc private func doneButtonTapped() {
        delegate?.imageViewControllerDidDismiss(self)
    }
}
