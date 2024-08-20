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
        
        self.setTitle("Halaman selanjutnya >", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

#Preview {
    NextButtonComponent()
}
