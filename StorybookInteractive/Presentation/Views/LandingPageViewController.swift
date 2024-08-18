//
//  LandingPageViewController.swift
//  StorybookInteractive
//
//  Created by Elsavira T on 18/08/24.
//

import Foundation
import UIKit

class LandingPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.66, green: 0.8, blue: 0.71, alpha: 1)
        
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: 414),
            nameTextField.heightAnchor.constraint(equalToConstant: 56),
            
            nextButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 361),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 270),
            nextButton.heightAnchor.constraint(equalToConstant: 64)

        ])
    }
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Halo! Siapa Nama Anakmu?"
        title.textColor = .black
        title.font = UIFont.boldSystemFont(ofSize: 34)
        return title
    }()
    
    private let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Nama Anak"
        nameTextField.layer.cornerRadius = 25
        nameTextField.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 0.88, alpha: 1)
        return nameTextField
    }()
    
    private let nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = UIColor(red: 0.69, green: 0.57, blue: 0.83, alpha: 1)
        nextButton.layer.cornerRadius = 16
        nextButton.setTitle("Lanjutkan", for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        return nextButton
    }()
}

#Preview {
    LandingPageViewController()
}
