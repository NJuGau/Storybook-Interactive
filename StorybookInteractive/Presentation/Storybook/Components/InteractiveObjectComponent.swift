//
//  InteractiveObjectComponent.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 16/08/24.
//

import Foundation
import UIKit

// COMPONENT TO LOAD BACKGROUND IMAGE ON STORYBOOK VIEW
class InteractiveObjectComponent: UIImageView {
    
    private var imageView: UIImageView!
        
    init(imageName: String, padding: UIEdgeInsets, size: CGSize) {
        super.init(frame: .zero)
        setupImageView(imageName: imageName)
        setupConstraints(padding: padding, size: size)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // You can also initialize the imageView here if you need to support storyboards
    }
    
    private func setupImageView(imageName: String) {
        imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
    }
    
    private func setupConstraints(padding: UIEdgeInsets, size: CGSize) {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding.top),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding.bottom),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding.left),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding.right),
            imageView.heightAnchor.constraint(equalToConstant: size.height),
            imageView.widthAnchor.constraint(equalToConstant: size.width)
        ])
    }
}
