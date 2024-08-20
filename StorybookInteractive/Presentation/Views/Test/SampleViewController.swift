//
//  SampleViewController.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 15/08/24.
//

import UIKit

class SampleViewController: UIViewController, ScanningDelegate {
    
    var scanResult: String?
    var scanningView: ScanningViewController?
    
    let soundManager = SoundManager.shared
    
    func didScanCompleteDelegate(_ controller: ScanningViewController, didCaptureResult identifier: String) {
        print("identifier: \(identifier)")
        scanResult = identifier
        removeScanningView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
        
        scanningView = ScanningViewController(promptText: "Di suatu pagi yang cerah...")
        scanningView?.delegate = self
        view.addSubview(scanningView?.view ?? UIView())
        
        soundManager.setupBackgroundSound(soundName: "SampleBackground")
        soundManager.setupDialogueSound(soundName: "SampleForeground")
        soundManager.playBackgroundSound()
        soundManager.playDialogueSound()
    }

    func removeScanningView() {
        DispatchQueue.main.async { [weak self] in
                self?.scanningView?.view.removeFromSuperview() // Remove the view
                self?.scanningView = nil // Set the reference to nil
            }
    }
}
