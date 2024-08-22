//
//  ButtonComponent.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 15/08/24.
//

import UIKit

class ButtonComponent: UIButton {
    
        let homeButton: UIButton = {
            let homeButton = UIButton()
            let image = UIImage(systemName: "house.fill")

            homeButton.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 0.88, alpha: 1)
            homeButton.setImage(image, for: .normal)
            homeButton.tintColor = UIColor(red: 0.41, green: 0.53, blue: 0.45, alpha: 1)
            homeButton.frame = CGRect(x: 28, y: 40, width: 69, height: 69)
            homeButton.layer.cornerRadius = 69 / 2
            homeButton.clipsToBounds = true
            
            return homeButton
            
        
        }()
    
    
    @objc func buttonTapped() {
            print("Circle button tapped!")
        }

    
}

extension UIImage {
  public static func pixel(ofColor color: UIColor) -> UIImage {
    let pixel = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)

    UIGraphicsBeginImageContext(pixel.size)
    defer { UIGraphicsEndImageContext() }

    guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }

    context.setFillColor(color.cgColor)
    context.fill(pixel)

    return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
  }
}

extension UIButton {
    func setBackgroundColor(_ backgroundColor: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(.pixel(ofColor: backgroundColor), for: state)
    }
}
