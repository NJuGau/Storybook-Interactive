//
//  StartScanningOverlayViewController.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 21/08/24.
//

import UIKit

class StartScanningOverlayViewController: UIViewController {

    private let backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(imageLiteralResourceName: "OverlayScan")
        backgroundImage.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 942.85 / 2, y: 176, width: 942.85, height: 557.99)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImage
    }()
    
    private let initialLabel: UILabel = {
        let label = UILabel()
        label.text = "Ayo Cari"
        label.textColor = UIColor(named: "DarkBrown")
        label.textAlignment = .center
        
        guard let customFont = UIFont(name: "LibreBodoni-Italic_SemiBold-Italic", size: 64) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        label.font = customFont
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let rotationAngle = -2 * CGFloat.pi / 180
        label.transform = CGAffineTransform(rotationAngle: rotationAngle)
        return label
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(named: "DarkBrown")
        label.textAlignment = .center
        
        guard let customFont = UIFont(name: "LibreBodoni-Italic_SemiBold-Italic", size: 64) else {
            fatalError("""
                Failed to load the "LibreBodoni-Italic_SemiBold-Italic" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        label.font = customFont
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let rotationAngle = -2 * CGFloat.pi / 180
        label.transform = CGAffineTransform(rotationAngle: rotationAngle)
        return label
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Pindai Kartu untuk Melanjutkan Cerita"
        label.textColor = UIColor(named: "DarkBrown")
        label.textAlignment = .center
        
        guard let customFont = UIFont(name: "Nunito-Bold", size: 17) else {
            fatalError("""
                Failed to load the "Nunito-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        label.font = customFont
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let rotationAngle = -2 * CGFloat.pi / 180
        label.transform = CGAffineTransform(rotationAngle: rotationAngle)
        return label
    }()
    
    init(promptText: String) {
        super.init(nibName: nil, bundle: nil)
        promptLabel.text = "Kartu " + promptText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(backgroundImage)
        view.addSubview(initialLabel)
        view.addSubview(promptLabel)
        view.addSubview(instructionLabel)
        
        setupConstraint()
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 176)
        ])
        
        NSLayoutConstraint.activate([
            initialLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 270),
            initialLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 200),
            initialLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -200)
        ])
        
        NSLayoutConstraint.activate([
            promptLabel.topAnchor.constraint(equalTo: initialLabel.bottomAnchor),
            promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 200),
            promptLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -200)
        ])
        
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: 44),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 200),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -200)
        ])
    }
}
