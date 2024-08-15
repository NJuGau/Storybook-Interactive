//
//  SampleViewController.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 15/08/24.
//

import UIKit

class SampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
        
        let scanningView = ScanningViewController()
        
        view.addSubview(scanningView.view)
    }

}
