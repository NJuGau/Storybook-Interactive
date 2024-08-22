//
//  LetsReadViewController.swift
//  StorybookInteractive
//
//  Created by Elsavira T on 20/08/24.
//

import Foundation
import UIKit

class LetsReadViewController: UIViewController {
    
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
        
        view.addSubview(buttonNextPage)
        
        NSLayoutConstraint.activate([
         buttonNextPage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
         buttonNextPage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
        ])
    }
    
    @objc
    private func gotostorybook() {
        let bookController = BookViewController()
        bookController.modalPresentationStyle = .fullScreen
        self.present(bookController, animated: true, completion: nil)
    }
    
}


#Preview {
    LetsReadViewController()
}
