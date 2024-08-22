//
//  TheEndScreenViewController.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 22/08/24.
//

import UIKit

class TheEndScreenViewController: UIViewController {

    private let endLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 518, y: 397, width: 159, height: 60))
        label.text = "Tamat"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        guard let customFont = UIFont(name: "Nunito-Bold", size: 54) else {
            fatalError("""
                Failed to load the "Nunito-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        label.font = customFont
        label.alpha = 0.0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Black500")
        
        view.addSubview(endLabel)
        
        setupConstraint()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateLabelFadeIn()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            endLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            endLabel.widthAnchor.constraint(equalToConstant: 159),
            endLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func animateLabelFadeIn() {
            UIView.animate(withDuration: 1.0,
                           delay: 0.0,
                           options: .curveEaseIn,
                           animations: {
                self.endLabel.alpha = 1.0
            }, completion: nil)
        }
}
