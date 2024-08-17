//
//  NextButtonComponent.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 14/08/24.
//

import Foundation
import UIKit

class NextButtonComponent: UIButton {
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let button = UIButton(type: .infoLight)
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemBlue
        button.frame = frame
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        self.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
