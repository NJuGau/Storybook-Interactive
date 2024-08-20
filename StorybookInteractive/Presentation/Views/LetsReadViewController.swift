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
        
        view.addSubview(bookTitle)
        view.addSubview(startReadingButton)
        view.addSubview(homeButton)
        
        NSLayoutConstraint.activate([
            bookTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bookTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -240),
            
            startReadingButton.topAnchor.constraint(equalTo: bookTitle.bottomAnchor, constant: 450),
            startReadingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startReadingButton.widthAnchor.constraint(equalToConstant: 270),
            startReadingButton.heightAnchor.constraint(equalToConstant: 64),
            
            homeButton.widthAnchor.constraint(equalToConstant: 69),
            homeButton.heightAnchor.constraint(equalToConstant: 69),
            homeButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -374),
            homeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32)
        ])
    }
    
    private let bookTitle: UILabel = {
        let bookTitle = UILabel()
        bookTitle.translatesAutoresizingMaskIntoConstraints = false
        bookTitle.text = "Judul Buku"
        bookTitle.font = UIFont.boldSystemFont(ofSize: 74)
        return bookTitle
    }()
    
    private let startReadingButton: UIButton = {
        let startReadingButton = UIButton()
        startReadingButton.translatesAutoresizingMaskIntoConstraints = false
        startReadingButton.backgroundColor = UIColor(red: 0.53, green: 0.68, blue: 0.58, alpha: 1)
        startReadingButton.layer.cornerRadius = 16
        startReadingButton.setTitle("Mulai Membaca", for: .normal)
        startReadingButton.titleLabel?.font = .boldSystemFont(ofSize: 28)
        return startReadingButton
    }()
    
    private let homeButton: UIButton = {
        let homeButton = UIButton()
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 0.88, alpha: 1)
        homeButton.layer.cornerRadius = 69 / 2
        homeButton.clipsToBounds = true
        let buttonImage = UIImage(named: "home")
        homeButton.setImage(buttonImage, for: .normal)
        return homeButton
    }()
    
}

#Preview {
    LetsReadViewController()
}
