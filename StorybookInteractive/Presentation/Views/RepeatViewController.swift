//
//  RepeatViewController.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 19/08/24.
//

import UIKit

protocol RepeatDelegate {
    func didPressCloseDelegate(_ controller: RepeatViewController)
    func didPressCardDelegate(_ controller: RepeatViewController)
}

class RepeatViewController: UIViewController {
    
    var delegate: RepeatDelegate?
    var cardImageName: String = ""
    
    private let closeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tekan untuk menutup"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let cardButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 168.4, y: 100, width: 338.8, height: 474.32)
        button.backgroundColor = .clear
        return button
    }()
    
    private let cardImage: UIImageView = {
        let image = UIImageView()
        image.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 168.4, y: 100, width: 338.8, height: 474.32)
        return image
    }()
    
    private let backgroundTouchArea: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    init(cardImageName: String) {
        super.init(nibName: nil, bundle: nil)
        cardButton.setImage(UIImage(imageLiteralResourceName: cardImageName), for: .normal)
        cardImage.image = UIImage(imageLiteralResourceName: cardImageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundTouchArea)
//        view.addSubview(cardButton)
        view.addSubview(cardImage)
        view.addSubview(closeLabel)
        
        let completeGesture = UITapGestureRecognizer(target: self, action: #selector(onCompletePress(_:)))
        backgroundTouchArea.addGestureRecognizer(completeGesture)
        
        //TODO: Bugged click
//        let repeatGesture = UITapGestureRecognizer(target: self, action: #selector(onCardPress(_:)))
//        cardButton.addGestureRecognizer(repeatGesture)
        
        setupConstraint()
    }
    
    @objc
    private func onCompletePress(_ sender: UITapGestureRecognizer) {
        delegate?.didPressCloseDelegate(self)
    }
    
    @objc
    private func onCardPress(_ sender: UIButton) {
        delegate?.didPressCardDelegate(self)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            backgroundTouchArea.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundTouchArea.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundTouchArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundTouchArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            closeLabel.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 14),
            closeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            cardButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
//            cardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
        
        NSLayoutConstraint.activate([
            cardImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            cardImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
