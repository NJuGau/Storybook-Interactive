//
//  VideoHandler.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 14/08/24.
//

import Foundation
import AVFoundation

protocol VideoHandlerDelegate {
    func videoCapture(_ capture: VideoHandler, didCaptureVideoFrame: CVPixelBuffer?)
}

class VideoHandler: NSObject {
    var previewLayer: AVCaptureVideoPreviewLayer?
        var delegate: VideoHandlerDelegate?
        
        var fps = 15 // Change this if needed
        
        let captureSession = AVCaptureSession()
        let videoOutput = AVCaptureVideoDataOutput()
        
        let queue = DispatchQueue(label: "com.BtmProduction.camera-queue")
        
    public func setUp(sessionPreset: AVCaptureSession.Preset = .vga640x480, completion: @escaping (Bool) -> Void) {
            DispatchQueue.global(qos: .userInitiated).async {
                self.setUpCamera(sessionPreset: sessionPreset, completion: { success in
                    DispatchQueue.main.async {
                        completion(success)
                    }
                })
            }
    }
        
    private func setUpCamera(sessionPreset: AVCaptureSession.Preset, completion: @escaping (Bool) -> Void) {
            captureSession.beginConfiguration()
            captureSession.sessionPreset = sessionPreset
            
            guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
                print("Error: no video devices available")
                completion(false)
                return
            }
            
            guard let videoInput = try? AVCaptureDeviceInput(device: captureDevice) else {
                print("Error: could not create AVCaptureDeviceInput")
                completion(false)
                return
            }
            
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
            
            let settings: [String: Any] = [
                kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)
            ]
            
            videoOutput.videoSettings = settings
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: queue)
            
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            captureSession.commitConfiguration()
            
            DispatchQueue.main.async {
                self.configurePreviewLayer()
                completion(true)
            }
        }
        
        private func configurePreviewLayer() {
            if let previewLayer = self.previewLayer {
                previewLayer.removeFromSuperlayer()
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.videoGravity = .resizeAspect

            previewLayer?.connection?.videoRotationAngle = 180

            DispatchQueue.main.async {
                self.delegate?.videoCapture(self, didCaptureVideoFrame: nil) // Update or notify the delegate
            }
        }
        
        public func start() {
            if !captureSession.isRunning {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.captureSession.startRunning()
                }
            }
        }
        
        public func stop() {
            if captureSession.isRunning {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.captureSession.stopRunning()
                }
            }
        }
}

extension VideoHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        delegate?.videoCapture(self, didCaptureVideoFrame: imageBuffer)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}
