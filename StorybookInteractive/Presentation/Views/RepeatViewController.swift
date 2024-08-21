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
    
    private let cardImage: UIImageView = {
        let image = UIImageView()
        image.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 150, y: 100, width: 338.8, height: 474.32)
        return image
    }()
    
    init(cardImageName: String) {
        super.init(nibName: nil, bundle: nil)
        cardImage.image = UIImage(imageLiteralResourceName: cardImageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(cardImage)
        view.addSubview(closeLabel)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCompletePress(_ :))))
        setupConstraint()
    }
    
    @objc
    private func onCompletePress(_ sender: UITapGestureRecognizer) {
        delegate?.didPressCloseDelegate(self)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            closeLabel.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 14),
            closeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cardImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            cardImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

}
