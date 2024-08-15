//
//  ScanningView.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 14/08/24.
//

import UIKit
import Vision

class ScanningViewController: UIViewController {

    private let cameraView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue // Set a background color to see it more clearly
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name"
        label.textColor = .black // Ensure the text is visible
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let confidenceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Confidence"
        label.textColor = .black // Ensure the text is visible
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let classificationModel = try! ClassifyCardModel(configuration: .init())
        
    var videoHandler: VideoHandler!
        
    var request: VNCoreMLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add subviews
        view.addSubview(cameraView)
        view.addSubview(nameLabel)
        view.addSubview(confidenceLabel)
        
        // Setup constraints for cameraView
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            cameraView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            cameraView.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        // Setup constraints for nameLabel to be below cameraView
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100), // Adjust the spacing as needed
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            confidenceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10), // Adjust the spacing as needed
            confidenceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        setupModel()
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
//            videoHandler.start() // Cause of error
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            videoHandler.stop()
        }
        
        func setupModel(){
            if let visionModel = try? VNCoreMLModel(for: classificationModel.model) {
                request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
                request?.imageCropAndScaleOption = .scaleFill
            } else {
                fatalError()
            }
        }
        
        func setupCamera(){
            videoHandler = VideoHandler()
            videoHandler.delegate = self
            videoHandler.fps = 50
            videoHandler.setUp(sessionPreset: .vga640x480) { success in
                
                if success {
                    if let previewLayer = self.videoHandler.previewLayer {
                        self.cameraView.layer.addSublayer(previewLayer)
                        self.resizePreviewLayer()
                    }
                    
                    self.videoHandler.start()
                }
            }
        }
        
        func resizePreviewLayer() {
            videoHandler.previewLayer?.frame = cameraView.bounds
        }
}

extension ScanningViewController: VideoHandlerDelegate {
    func videoCapture(_ capture: VideoHandler, didCaptureVideoFrame: CVPixelBuffer?) {
        if let pixelBuffer = didCaptureVideoFrame {
            self.predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }
}

extension ScanningViewController {
    
    func predictUsingVision(pixelBuffer: CVPixelBuffer){
        guard let request = request else {
            fatalError()
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }

    func visionRequestDidComplete(request: VNRequest, error: Error?){
        if let classificationResults = request.results as? [VNClassificationObservation] {
            guard let result = classificationResults.first else {
                showFailResult()
                return
            }
            
            showResults(objectLabel: result.identifier, confidence: result.confidence)
        }
    }

    func showFailResult() {
        DispatchQueue.main.sync {
            self.nameLabel.text = "n/a result"
            self.confidenceLabel.text = "-- %"
        }
    }

    func showResults(objectLabel: String, confidence: VNConfidence) {
        DispatchQueue.main.sync {
            self.nameLabel.text = objectLabel
            self.confidenceLabel.text = "\(round(confidence * 100)) %"
        }
    }
}
