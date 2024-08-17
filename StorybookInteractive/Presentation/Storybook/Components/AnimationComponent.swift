//
//  AnimationComponent.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 13/08/24.
//

import Foundation
import UIKit

// COMPONENT TO CREATE ANIMATION TO MAKE INTERACTIVE ON STORY BOOK
internal class AnimationComponent: UIImageView {
    
    private var imageView: UIImageView!
    
    // Initialize the UIImageView with the provided
    init(image: UIImageView, frame: CGRect) {
        super.init(frame: frame)
        imageView = image
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func walkAnimation(duration: TimeInterval = 5.0, distance: CGFloat? = nil) {
        let distanceToMove = distance ?? (superview?.frame.width ?? UIScreen.main.bounds.width) - imageView.frame.width - 40
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveLinear, .repeat],
            animations: { self.imageView.transform = CGAffineTransform(translationX: distanceToMove, y: 0)
        }, completion: nil)
    }
}
