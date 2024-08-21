//
//  LearningGuidanceViewController.swift
//  StorybookInteractive
//
//  Created by Elsavira T on 15/08/24.
//

import Foundation
import UIKit

class LearningGuidanceViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(backgroundView)
        backgroundView.addSubview(tutorialLabel)
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: 900),
            backgroundView.heightAnchor.constraint(equalToConstant: 650)
        ])
        
        NSLayoutConstraint.activate([
            tutorialLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tutorialLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -250)
        
        ])
    }
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let tutorialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tutorial"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 64)
        
        return label
    }()
    
    
}
