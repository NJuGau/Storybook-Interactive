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
        view.backgroundColor = .clear
        return view
    }()
    
    private let dummyButton: UIButton = {
        
        let button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Mulai Cari", for: .normal)
        
        guard let customFont = UIFont(name: "Nunito-Bold", size: 16) else {
            fatalError("""
                Failed to load the "Nunito-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        button.titleLabel?.font = customFont
        
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "DarkGreen600")
        
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        let rotationAngle = -2 * CGFloat.pi / 180
        button.transform = CGAffineTransform(rotationAngle: rotationAngle)
        return button
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        
        guard let customFont = UIFont(name: "Nunito-Bold", size: 22) else {
            fatalError("""
                Failed to load the "Nunito-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        label.font = customFont
        return label
    }()
    
    private var initialFrame: StartScanningOverlayViewController?
  
    private let classificationModel = try! AllCardClassifier(configuration: .init())
        
    var videoHandler: VideoHandler!
    var request: VNCoreMLRequest?
    
    init(promptText: String) {
        super.init(nibName: nil, bundle: nil)
        self.promptText = promptText
        promptLabel.text = "Pindai kartu " + self.promptText
        initialFrame = StartScanningOverlayViewController(promptText: promptText)
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
            view.backgroundColor = .black.withAlphaComponent(0.7)
            view.addSubview(initialFrame?.view ?? UIView())
            view.addSubview(dummyButton)
          
            dummyButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startScanning(_ :))))
            
            setupModel()
            setupConstraintInitial()
        case .scan:
            dummyButton.isHidden = true
            view.addSubview(cameraView)
            view.addSubview(promptLabel)
            setupConstraintScan()
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
        initialFrame?.view.removeFromSuperview()
        initialFrame = nil
        scanState = .scan
    }
    
    
    private func setupConstraintInitial() {
       
        
        NSLayoutConstraint.activate([
            dummyButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 519),
            dummyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 400),
            dummyButton.widthAnchor.constraint(equalToConstant: 213),
            dummyButton.heightAnchor.constraint(equalToConstant: 48),
        ])
        
        
    }
    
    private func setupConstraintScan() {
        
        NSLayoutConstraint.activate([
            promptLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 144),
            promptLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptLabel.heightAnchor.constraint(equalToConstant: 64),
            promptLabel.widthAnchor.constraint(equalTo: cameraView.widthAnchor, multiplier: 0.5)
        ])
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: 20),
            cameraView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraView.widthAnchor.constraint(equalToConstant: 843),
            cameraView.heightAnchor.constraint(equalToConstant: 490)
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
            if result.confidence > 0.99 && result.identifier != "NonClassified" {
                print(result.identifier)
                delegate?.didScanCompleteDelegate(self, didCaptureResult: result.identifier)
            }
        }
    }
}
