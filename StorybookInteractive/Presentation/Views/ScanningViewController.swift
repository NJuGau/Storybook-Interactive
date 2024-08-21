//
//  ScanningView.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 14/08/24.
//

import UIKit
import Vision

enum ScanState {
    case initial, scan, complete
}

protocol ScanningDelegate {
    func didScanCompleteDelegate(_ controller: ScanningViewController, didCaptureResult identifier: String)
}

class ScanningViewController: UIViewController {
    
    var delegate: ScanningDelegate?
    

    var scanState: ScanState = .initial {
        didSet {
            checkState()
        }
    }
    var promptText: String = ""

    private let cameraView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let dummyButton: UIButton = {
        let button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Scanning!", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .red
        
        return button
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.backgroundColor = .white
        return label
    }()
  
    private let classificationModel = try! AllCardClassifier(configuration: .init())
        
    var videoHandler: VideoHandler!
        
    var request: VNCoreMLRequest?
    
    init(promptText: String) {
        super.init(nibName: nil, bundle: nil)
        self.promptText = promptText
        promptLabel.text = self.promptText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkState()
    }
    
    func checkState() {
        switch scanState {
        case .initial:
            view.addSubview(cameraView)
            view.addSubview(dummyButton)
            view.addSubview(promptLabel)
          
            dummyButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startScanning(_ :))))
            
            setupModel()
            setupConstraint()
        case .scan:
            dummyButton.isHidden = true
            setupCamera()
        case .complete:
            print("complete")
        }
    }
    
    private func setupScan() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(startScanning))
    }
    
    @objc
    private func startScanning(_ sender: UITapGestureRecognizer) {
        scanState = .scan
    }
    
    
    private func setupConstraint() {
        // Setup constraints for cameraView
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150), //change constant to 0 for phone
            cameraView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            cameraView.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        NSLayoutConstraint.activate([
            dummyButton.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            dummyButton.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
            dummyButton.heightAnchor.constraint(equalToConstant: 100),
            dummyButton.widthAnchor.constraint(equalTo: cameraView.widthAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            promptLabel.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            promptLabel.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor, constant: -150),
            promptLabel.heightAnchor.constraint(equalToConstant: 64),
            promptLabel.widthAnchor.constraint(equalTo: cameraView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
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
                return
            }
            
            //check if it werent non-classified
            if result.confidence > 0.90 && result.identifier != "NonClassified" {
                print(result.identifier)
                delegate?.didScanCompleteDelegate(self, didCaptureResult: result.identifier)
            }
        }
    }
}
