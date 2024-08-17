//
//  BackgroundViewComponent.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 13/08/24.
//

import Foundation
import UIKit

// COMPONENT TO LOAD BACKGROUND IMAGE ON STORYBOOK VIEW
class BackgroundViewComponent: UIImageView {
    
    private var imageView: UIImageView!
    private let scale = UIScreen.main.scale
    
    init(image: UIImage, frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = self.frame
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        self.addSubview(imageView)

        NSLayoutConstraint.activate([            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
