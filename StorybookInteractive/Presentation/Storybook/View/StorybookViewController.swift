//
//  FirstPageViewController.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 13/08/24.
//

import Foundation
import UIKit

class StorybookViewController: UIViewController {

    private var viewModel: StorybookViewModel!
    private var background: UIImageView!
    private var stories: [StoryPage] = []
    private var isScan = false
    private let scale = UIScreen.main.scale
    private var lottieManager: LottieManager?
    private var page = 1
    private var storyText = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        loadPage(pageNumber: page)
        
        // ADD TAP GESTURE
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeBackgroundImage))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("scan", isScan)
        // IMAGE AFTER SCAN
        if isScan{
            imageAfterScan()
        }
    }
    
    private func loadPage(pageNumber: Int){
        guard pageNumber > 0 && pageNumber <= stories.count else { return }

        page = pageNumber
        self.storyText = 0
        
        // Clear previous views
        view.subviews.forEach { $0.removeFromSuperview() }
        
        // Load background
        background = BackgroundViewComponent(image: UIImage(named: stories[page-1].backgroundImage[0])!, frame: view.bounds)
        view.addSubview(background)
        
        // Load story text
        addStoryText(index: self.storyText)
        
        // SCAN FLASH CARD

    }
    
    private func setupViewModel() {
        let repository = JSONStorybookRepository()
        let useCase = StorybookUsecase(storyRepository: repository)
        viewModel = StorybookViewModel(bookId: 1, storyId: page, textStoryId: storyText+1, useCase: useCase)
        stories = viewModel.loadData()

    }


    private func addStoryText(index: Int) {
        guard index < stories[page-1].listTextStory.count else { return }
        
        let storyLabel = UILabel()
        let storyText = stories[page-1].listTextStory[index].text
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        storyLabel.numberOfLines = 4
        storyLabel.font = UIFont.systemFont(ofSize: 28)
        storyLabel.textColor = .black
        view.addSubview(storyLabel)

        NSLayoutConstraint.activate([
            storyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: stories[page-1].listTextStory[index].padding.top / scale * 0.8),
            storyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: stories[page-1].listTextStory[index].padding.left / scale * 0.8),
//            storyLabel.heightAnchor.constraint(equalTo: view.heightAnchor),
//            storyLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        // Animated text appearance
        storyLabel.text = ""
        var currentIndex = 0

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if currentIndex < storyText.count {
                let index = storyText.index(storyText.startIndex, offsetBy: currentIndex)
                storyLabel.text?.append(storyText[index])
                currentIndex += 1
            } else {
                timer.invalidate()
                self.storyText += 1
                self.imageAfterScan()
            }
        }
    }
    
    private func imageAfterScan() {
        // INIT IMAGE
        if stories[page-1].listInteractiveObject[0] != nil {
            let image = createImage(imageName: stories[page-1].listInteractiveObject[0].objectImage)

            view.addSubview(image)
                        
            setupConstraint(
                image: image,
                top: stories[page-1].listInteractiveObject[0].padding.top,
                bottom: stories[page-1].listInteractiveObject[0].padding.bottom,
                right: stories[page-1].listInteractiveObject[0].padding.right,
                left: stories[page-1].listInteractiveObject[0].padding.left,
                height: stories[page-1].listInteractiveObject[0].size.height,
                width: stories[page-1].listInteractiveObject[0].size.width
            )
            
            // BIRD 1
            startLottie(x: 150, y: 55)
//                stopLottie()
        }
        
        if stories[page-1].listInteractiveObject[1] != nil {
            let image = createImage(imageName: stories[page-1].listInteractiveObject[1].objectImage)

            view.addSubview(image)
                        
            setupConstraint(
                image: image,
                top: stories[page-1].listInteractiveObject[1].padding.top,
                bottom: stories[page-1].listInteractiveObject[1].padding.bottom,
                right: stories[page-1].listInteractiveObject[1].padding.right,
                left: stories[page-1].listInteractiveObject[1].padding.left,
                height: stories[page-1].listInteractiveObject[1].size.height,
                width: stories[page-1].listInteractiveObject[1].size.width
            )
            
            // BIRD 2
            startLottie(x: 780, y: 45)
//                stopLottie()
            
            //Setup button next page
            let buttonNextPage = NextButtonComponent()
            
            view.addSubview(buttonNextPage)
            
            //TODO: Change constant to make it responsive
            NSLayoutConstraint.activate([
                buttonNextPage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
                buttonNextPage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            ])
            //TODO: Implement touch gesture
        }
    }
    
    
    
    @objc
    private func changeBackgroundImage() {
        // TODO: CHANGE THIS TOGGLE TO IMAGE SCAN
        isScan = true
        
        let newBackground = BackgroundViewComponent(image: UIImage(named: stories[0].backgroundImage[1])!, frame: view.bounds)
        
        newBackground.alpha = 0
        view.addSubview(newBackground)
        
        view.sendSubviewToBack(newBackground)
            
        UIView.transition(with: view, duration: 1, options: .curveEaseInOut, animations: {
            self.background.alpha = 0
            newBackground.alpha = 1
        }) { _ in
            self.background.removeFromSuperview()
            self.background = newBackground
        }
        
        if stories[page-1].listInteractiveObject[2] != nil {
            let image = createImage(imageName: stories[0].listInteractiveObject[2].objectImage)
            view.addSubview(image)
                        
            setupConstraint(
                image: image,
                top: stories[page-1].listInteractiveObject[2].padding.top,
                bottom: stories[page-1].listInteractiveObject[2].padding.bottom,
                right: stories[page-1].listInteractiveObject[2].padding.right,
                left: stories[page-1].listInteractiveObject[2].padding.left,
                height: stories[page-1].listInteractiveObject[2].size.height,
                width: stories[page-1].listInteractiveObject[2].size.width
            )
            // FOX
            startLottie(x: 250, y: 410)
            UIView.transition(with: view, duration: 1, options: .curveEaseInOut, animations: {
                image.alpha = 0
                image.alpha = 1
            })
        }

        if stories[page-1].listInteractiveObject[3] != nil {
            let image = createImage(imageName: stories[0].listInteractiveObject[3].objectImage)

            view.addSubview(image)
                        
            setupConstraint(
                image: image,
                top: stories[page-1].listInteractiveObject[3].padding.top,
                bottom: stories[page-1].listInteractiveObject[3].padding.bottom,
                right: stories[page-1].listInteractiveObject[3].padding.right,
                left: stories[page-1].listInteractiveObject[3].padding.left,
                height: stories[page-1].listInteractiveObject[3].size.height,
                width: stories[page-1].listInteractiveObject[3].size.width
            )

            // CAT
            startLottie(x: 630, y: 420)
            
            UIView.transition(with: view, duration: 1, options: .curveEaseInOut, animations: {
                image.alpha = 0
                image.alpha = 1
            })
            
            self.addStoryText(index: storyText+1)
        }
    }
    
    private func createImage(imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }
    
    private func setupConstraint(image: UIImageView,top: Double, bottom: Double, right: Double, left: Double, height: Double, width: Double) {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: top/scale*0.8),
            image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left/scale*0.8),
            image.widthAnchor.constraint(equalToConstant: width/scale*0.7),
            image.heightAnchor.constraint(equalToConstant:height/scale*0.7)
        ])
    }
}

extension StorybookViewController {
    private func popupAnimation(image: UIImageView) {
        UIView.animate(withDuration: 0.9,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.9,
                       options: [.autoreverse, .repeat],
                       animations: {
            image.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            image.layer.removeAllAnimations()
        }

    }
    
    private func startLottie(x: Double, y: Double) {
        lottieManager = LottieManager(fileName: "LottieHandTap", loopMode: .loop, speed: 1.0)
        
        lottieManager?.attachToView(self.view, frame: CGRect(x: x, y: y, width: 100, height: 100))
        
        lottieManager?.play()
    }
    
    private func stopLottie() {
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] timer in
            self?.lottieManager?.stop()
            
            timer.invalidate()
        }
    }


    // DISPLAY STORY TEXT
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                let storyVC = StoryTextViewController(storyText: story.listTextStory[0].text, x: story.listTextStory[0].position.xPosition, y: story.listTextStory[0].position.yPosition, width: story.listTextStory[0].position.width, height: story.listTextStory[0].position.height)
//                self.present(storyVC, animated: true, completion: nil)
//            }

    
    //            // SETUP POP UP ANIMATION
    //            popupAnimation()
    //
    //            // ADD GESTURE ON IMAGE
    //            let singleTapImage = setupSingleTabGestureImage()
    //            singleTapImage.numberOfTapsRequired = 1
    //            imageView.addGestureRecognizer(singleTapImage)
    //
    //            let doubleTapImage = setupDoubleGestureImage()
    //            doubleTapImage.numberOfTapsRequired = 2
    //            imageView.addGestureRecognizer(doubleTapImage)
    //
    //            singleTapImage.require(toFail: doubleTapImage)

    
//    private func setupSingleTabGestureImage() -> UITapGestureRecognizer {
//        return UITapGestureRecognizer(target: self, action: #selector(singleTapImage))
//    }
//    
//    private func setupDoubleGestureImage() -> UITapGestureRecognizer {
//        return UITapGestureRecognizer(target: self, action: #selector(doubleTapImage))
//    }
//    
//    @objc
//    private func singleTapImage(_ sender: UITapGestureRecognizer) {
//        self.imageView.layer.removeAllAnimations()
//        if !isScale {
//            guard let imageView = sender.view as? UIImageView else { return }
//            UIView.animate(withDuration: 1,
//                           animations: {
//                imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
//            })
//            isScale = true
//        }
//        
//    }
//    
//    @objc
//    private func doubleTapImage(_ sender: UITapGestureRecognizer) {
//        if isScale {
//            guard let imageView = sender.view as? UIImageView else { return }
//            
//            UIView.animate(withDuration: 1,
//                           animations: {
//                imageView.transform = CGAffineTransform.identity
//            })
//            
//            isScale = false
//        }
//    }
}
