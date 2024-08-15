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
        view.addSubview(tutorialLabel)
        
        NSLayoutConstraint.activate([
            tutorialLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tutorialLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300)
        
        ])
    }
    
    private let tutorialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tutorial"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        
        return label
    }()
    
    
}
