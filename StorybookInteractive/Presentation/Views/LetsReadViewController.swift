//
//  LetsReadViewController.swift
//  StorybookInteractive
//
//  Created by Elsavira T on 20/08/24.
//

import Foundation
import UIKit

class LetsReadViewController: UIViewController {
    
    private var nextButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(backgroundImageView)
        view.addSubview(bookTitle)
        view.addSubview(appLogo)
        
        NSLayoutConstraint.activate([
            bookTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bookTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -190),
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            appLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -330)
            
        ])
        
        setupNextPageButton()
        
        let vignetteView = createVignetteView()
        view.addSubview(vignetteView)
            
        NSLayoutConstraint.activate([
                vignetteView.topAnchor.constraint(equalTo: view.topAnchor),
                vignetteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                vignetteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                vignetteView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        if let button = nextButton {
            view.bringSubviewToFront(button)
        }
    }
    
    private let bookTitle: UIImageView = {
        let bookTitle = UIImageView()
        bookTitle.translatesAutoresizingMaskIntoConstraints = false
        bookTitle.image = UIImage(named: "Title")
        return bookTitle
    }()
    
    private let backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: "Cover")
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
    }()
    
    private let appLogo: UIImageView = {
        let appLogo = UIImageView()
        appLogo.translatesAutoresizingMaskIntoConstraints = false
        appLogo.image = UIImage(named: "Vocaloom")
        return appLogo
    }()

    private func setupNextPageButton() {
        let buttonNextPage = NextButtonComponent()
        buttonNextPage.addTarget(self, action: #selector(gotostorybook), for: .touchUpInside)
        nextButton = buttonNextPage
        view.addSubview(buttonNextPage)
        
        NSLayoutConstraint.activate([
         buttonNextPage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
         buttonNextPage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
        ])
    }
    
    private func createVignetteView() -> UIView {
        let vignetteView = UIView(frame: self.view.bounds)
        vignetteView.translatesAutoresizingMaskIntoConstraints = false
        vignetteView.isUserInteractionEnabled = false
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = vignetteView.bounds
        
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.7).cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        
        gradientLayer.locations = [0.0, 0.2, 0.8, 1.0]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        vignetteView.layer.addSublayer(gradientLayer)
        
        return vignetteView
    }
    
    @objc
    private func gotostorybook() {
        let bookController = BookViewController()
        bookController.modalPresentationStyle = .fullScreen
        self.present(bookController, animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
}


#Preview {
    LetsReadViewController()
}
