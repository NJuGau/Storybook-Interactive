//
//  FirstPageViewController.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 13/08/24.
//

import Foundation
import UIKit
import Combine


class StorybookViewController: UIViewController {

    private var viewModel: StorybookViewModel!
    private var imageView: UIImageView!
    private var stories: [StoryPage] = []
    private var isScale = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repository = JSONStorybookRepository()
        let useCase = StorybookUsecase(storyRepository: repository)
        viewModel = StorybookViewModel(bookId: 1, textStoryId: 1, useCase: useCase)
        
        stories = viewModel.loadData()
        
        for story in stories {
            // DISPLAY STORY TEXT
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                let storyVC = StoryTextViewController(storyText: story.listTextStory[0].text, x: story.listTextStory[0].position.xPosition, y: story.listTextStory[0].position.yPosition, width: story.listTextStory[0].position.width, height: story.listTextStory[0].position.height)
//                self.present(storyVC, animated: true, completion: nil)
//            }

            
            // INIT BACKGROUND VIEW
            let background = BackgroundViewComponent(image: UIImage(named: story.backgroundImage)!, frame: view.bounds)
            view.addSubview(background)
            
            // INIT IMAGE
            imageView = UIImageView()
            imageView.image = UIImage(named: story.listInteractiveObject[0].objectImage)
            imageView.isUserInteractionEnabled = true
            imageView.frame = view.bounds
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            
            setupConstraint(
                x: story.listInteractiveObject[0].position.xPosition,
                y: story.listInteractiveObject[0].position.yPosition,
                width: story.listInteractiveObject[0].position.width,
                height: story.listInteractiveObject[0].position.height
            )
            
            
            // SETUP POP UP ANIMATION
            popupAnimation()
            
            // ADD GESTURE ON IMAGE
            let singleTapImage = setupSingleTabGestureImage()
            singleTapImage.numberOfTapsRequired = 1
            imageView.addGestureRecognizer(singleTapImage)
            
            let doubleTapImage = setupDoubleGestureImage()
            doubleTapImage.numberOfTapsRequired = 2
            imageView.addGestureRecognizer(doubleTapImage)
                     
            singleTapImage.require(toFail: doubleTapImage)
            
            
        }
    }
}

extension StorybookViewController {
    private func setupConstraint(x: Double, y: Double, width: Double, height: Double) {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: x),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: y),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 500),
            imageView.widthAnchor.constraint(equalToConstant: width),
            imageView.heightAnchor.constraint(equalToConstant: height)
        ])

    }
    
    private func popupAnimation() {
        UIView.animate(withDuration: 0.9,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.9,
                       options: [.autoreverse, .repeat],
                       animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.imageView.layer.removeAllAnimations()
        }

    }


    private func setupSingleTabGestureImage() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(singleTapImage))
    }
    
    private func setupDoubleGestureImage() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(doubleTapImage))
    }
    
    
    @objc
    private func singleTapImage(_ sender: UITapGestureRecognizer) {
        self.imageView.layer.removeAllAnimations()
        if !isScale {
            guard let imageView = sender.view as? UIImageView else { return }
            UIView.animate(withDuration: 1,
                           animations: {
                imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            })
            isScale = true
        }
        
    }
    
    @objc
    private func doubleTapImage(_ sender: UITapGestureRecognizer) {
        if isScale {
            guard let imageView = sender.view as? UIImageView else { return }
            
            UIView.animate(withDuration: 1,
                           animations: {
                imageView.transform = CGAffineTransform.identity
            })
            
            isScale = false
        }
    }
}
