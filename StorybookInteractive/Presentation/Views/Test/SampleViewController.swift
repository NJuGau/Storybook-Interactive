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
    
    let soundManager = SoundManager.shared
    
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
        
//        scanningView = ScanningViewController(promptText: "Cari Burung yuk!")
//        scanningView?.delegate = self
//        view.addSubview(scanningView?.view ?? UIView())
//        
//        soundManager.setupBackgroundSound(soundName: "SampleBackground")
//        soundManager.setupDialogueSound(soundName: "SampleForeground")
//        soundManager.playBackgroundSound()
//        soundManager.playDialogueSound()
        
        let buttonNextPage = NextButtonComponent()
        
        view.addSubview(buttonNextPage)
        
        NSLayoutConstraint.activate([
            buttonNextPage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            buttonNextPage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
        ])
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
