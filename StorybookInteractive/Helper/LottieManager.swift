//
//  LottieManager.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 15/08/24.
//

import UIKit
import Lottie

public class LottieManager {
    
    private var animationView: Lottie.LottieAnimationView?
    
    public init(fileName: String, loopMode: LottieLoopMode = .loop, speed: CGFloat = 10) {
        setupAnimation(fileName: fileName, loopMode: loopMode, speed: speed)
    }
    
    private func setupAnimation(fileName: String, loopMode: LottieLoopMode, speed: CGFloat) {
        // Initialize the Lottie AnimationView
        animationView = Lottie.LottieAnimationView(name: fileName)
        animationView?.loopMode = loopMode
        animationView?.contentMode = .scaleAspectFill
        animationView?.animationSpeed = speed
    }
    
    // Method to attach the animation to a UIView
    public func attachToView(_ view: UIView, frame: CGRect? = nil) {
        guard let animationView = animationView else { return }
        
        // Set frame if provided
        if let frame = frame {
            animationView.frame = frame
        } else {
            animationView.frame = view.bounds
        }
        
        // Ensure the animation view resizes with the parent view
        animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add the animation view to the provided UIView
        view.addSubview(animationView)
    }
    
    // Method to play the animation
    public func play() {
        animationView?.play()
    }
    
    // Method to stop the animation
    public func stop() {
        animationView?.stop()
        animationView?.removeFromSuperview()
    }
    
    // Method to set the animation speed
    public func setSpeed(_ speed: CGFloat) {
        animationView?.animationSpeed = speed
    }
    
    // Method to set the loop mode of the animation
    public func setLoopMode(_ loopMode: LottieLoopMode) {
        animationView?.loopMode = loopMode
    }
    
    // Method to change the Lottie animation file
    public func changeAnimation(fileName: String) {
        animationView?.animation = LottieAnimation.named(fileName)
    }
}
