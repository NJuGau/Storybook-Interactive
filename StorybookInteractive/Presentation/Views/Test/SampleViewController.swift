//
//  SampleViewController.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 15/08/24.
//

import UIKit

class SampleViewController: UIViewController, ScanningDelegate, RepeatDelegate {
    
    
    var scanResult: String?
    var scanningView: ScanningViewController?
    var repeatView: RepeatViewController?
    
    func didScanCompleteDelegate(_ controller: ScanningViewController, didCaptureResult identifier: String) {
        print("identifier: \(identifier)")
        scanResult = identifier
        removeScanningView()
        addRepeatView()
    }
    
    func didPressCompleteDelegate(_ controller: RepeatViewController) {
        removeRepeatView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
        
        scanningView = ScanningViewController(promptText: "Cari Burung yuk!")
        scanningView?.delegate = self
        view.addSubview(scanningView?.view ?? UIView())
    }

    func removeScanningView() {
        DispatchQueue.main.async { [weak self] in
            self?.scanningView?.view.removeFromSuperview()
            self?.scanningView = nil
        }
    }
    
    func addRepeatView() {
        DispatchQueue.main.async { [weak self] in
            self?.repeatView = RepeatViewController(cardImageName: "BirdCard")
            self?.repeatView?.delegate = self
            self?.view.addSubview(self?.repeatView?.view ?? UIView())
        }
    }
    
    func removeRepeatView() {
        repeatView?.view.removeFromSuperview()
        repeatView = nil
    }
}
