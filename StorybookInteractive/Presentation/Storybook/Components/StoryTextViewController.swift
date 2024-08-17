//
//  StoryTextViewController.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 13/08/24.
//

import Foundation
import UIKit

// COMPONENT TO SHOW STORY TEXT
internal class StoryTextViewController: UIViewController {

    private var storyLabel: UILabel!
    private var backgroundView: UIView!
    private var storyText: String
    private var x: Double
    private var y: Double
    private var width: Double
    private var height: Double
    
    init(storyText: String, x: Double, y: Double, width: Double, height: Double) {
        self.storyText = storyText
        self.x = x
        self.y = y
        self.height = height
        self.width = width
        super.init(nibName: nil, bundle: nil)
    }

    // Required initializer for using the view controller from a storyboard or nib
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStoryLabel()
        startStoryAnimation()
    }

    private func setupStoryLabel() {
        storyLabel = UILabel()
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        storyLabel.numberOfLines = 0
        storyLabel.font = UIFont.systemFont(ofSize: 24)
        storyLabel.textColor = .black
        
        view.addSubview(storyLabel)

        NSLayoutConstraint.activate([
            storyLabel.widthAnchor.constraint(equalToConstant: width),
            storyLabel.heightAnchor.constraint(equalToConstant: height),
            storyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: x),
            storyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: y),
        ])
    }
    
    private func startStoryAnimation() {
        storyLabel.text = ""
        var currentIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if currentIndex < self.storyText.count {
                let index = self.storyText.index(self.storyText.startIndex, offsetBy: currentIndex)
                self.storyLabel.text?.append(self.storyText[index])
                currentIndex += 1
            } else {
                timer.invalidate()
                self.storyLabel.removeFromSuperview()
            }
        }
    }
}
