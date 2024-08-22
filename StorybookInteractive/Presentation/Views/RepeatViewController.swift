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
        
        guard let customFont = UIFont(name: "Nunito-Bold", size: 17) else {
            fatalError("""
                Failed to load the "Nunito-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        label.font = customFont
        
        return label
    }()
    
    private let cardButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 168.4, y: 230, width: 338.8, height: 474.32)
        button.backgroundColor = .clear
        return button
    }()
    
    private let cardImage: UIImageView = {
        let image = UIImageView()
        image.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 168.4, y: 230, width: 338.8, height: 474.32)
        return image
    }()
    
    private let backgroundTouchArea: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    private let appraisalLabel: UIView = {
        let baseView = UIView()
        let starLeft = UIImageView(image: UIImage(named: "StarLeft"))
        let starRight = UIImageView(image: UIImage(named: "StarRight"))
        let label = UILabel(frame: CGRect(x: 151, y: 15, width: 170, height: 41))
        
        starLeft.translatesAutoresizingMaskIntoConstraints = false
        starRight.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let customFont = UIFont(name: "Nunito-Bold", size: 54) else {
            fatalError("""
                Failed to load the "Nunito-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        label.font = customFont
        label.textColor = .white
        label.text = "Hebat!"
        
        baseView.addSubview(starLeft)
        baseView.addSubview(label)
        baseView.addSubview(starRight)
        
        NSLayoutConstraint.activate([
            starLeft.topAnchor.constraint(equalTo: baseView.topAnchor),
            starLeft.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            starLeft.widthAnchor.constraint(equalToConstant: 98),
            starLeft.heightAnchor.constraint(equalToConstant: 71),
        ])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: baseView.topAnchor),
            label.leadingAnchor.constraint(equalTo: starLeft.trailingAnchor, constant: 52),
            label.trailingAnchor.constraint(equalTo: starRight.leadingAnchor, constant: -52),
            label.widthAnchor.constraint(equalToConstant: 170),
            label.heightAnchor.constraint(equalToConstant: 71),
        ])
        
        NSLayoutConstraint.activate([
            starRight.topAnchor.constraint(equalTo: baseView.topAnchor),
            starRight.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            starRight.widthAnchor.constraint(equalToConstant: 98),
            starRight.heightAnchor.constraint(equalToConstant: 71),
        ])
        return baseView
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
        view.addSubview(appraisalLabel)
        view.addSubview(cardButton)
        view.addSubview(cardImage)
        view.addSubview(closeLabel)
        
        let completeGesture = UITapGestureRecognizer(target: self, action: #selector(onCompletePress(_:)))
        backgroundTouchArea.addGestureRecognizer(completeGesture)
        
        //TODO: Bugged click
        let repeatGesture = UITapGestureRecognizer(target: self, action: #selector(onCardPress(_:)))
        cardButton.addGestureRecognizer(repeatGesture)
        
        setupConstraint()
        animateCloseLabelBlinking()
        
        cardImage.frame.origin.y = view.frame.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            animateCardImageSwipeUp()
        }
    
    @objc
    private func onCompletePress(_ sender: UITapGestureRecognizer) {
        delegate?.didPressCloseDelegate(self)
    }
    
    @objc
    private func onCardPress(_ sender: UITapGestureRecognizer) {
        delegate?.didPressCardDelegate(self)
    }
    
    private func animateCloseLabelBlinking() {
        UIView.animate(withDuration: 0.8,
                       delay: 0.0,
                       options: [.repeat, .autoreverse],
                       animations: {
            self.closeLabel.alpha = 0.0
        }, completion: { _ in
            self.closeLabel.alpha = 1.0
        })
    }
    
    private func animateCardImageSwipeUp() {
        UIView.animate(withDuration: 0.8,
                           delay: 0.0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseOut,
                           animations: {
            self.cardImage.frame.origin.y = 230
        }, completion: nil)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            backgroundTouchArea.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundTouchArea.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundTouchArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundTouchArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            closeLabel.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 16),
            closeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            cardButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
//            cardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
        
        NSLayoutConstraint.activate([
            appraisalLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 111),
            appraisalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appraisalLabel.widthAnchor.constraint(equalToConstant: 473),
            appraisalLabel.heightAnchor.constraint(equalToConstant: 71),
        ])
        
        NSLayoutConstraint.activate([
            cardImage.topAnchor.constraint(equalTo: appraisalLabel.topAnchor, constant: 40),
            cardImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
