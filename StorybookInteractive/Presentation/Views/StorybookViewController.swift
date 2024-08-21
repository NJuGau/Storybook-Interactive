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
    private var storyLabel: UILabel!
    private var stories: [Story] = []
    private var images: [ObjectImage] = []
    private var imageScan: [ObjectImage] = []
    private var backgroundImage: [Background] = []
    private var isScan = false
    private var lottieManager: LottieManager?
    private var page = 1
    private var bookId: String = "37bff686-7d09-4e53-aa90-fb465da131b5"

    private var isImageScaled = false
    private var overlay: UIView?
    private var isLabelVisible = false

    private var nextPageButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SETUP VIEW MODEL
        setupViewModel()
        
        loadPage()
        
        // ADD TAP GESTURE
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeBackgroundImage))
        view.addGestureRecognizer(tapGesture)
        
        

    }
    
    
    
    
    private func loadPage(){
        // Load background
        background = BackgroundViewComponent(image: UIImage(named: backgroundImage[0].image)!, frame: view.bounds)
        view.addSubview(background)
        
        
        // LOAD IMAGE AFTER SCAN
        loadImageAfterScan()
        
        // Load story text
//        storyTextBeforeScan(text: stories[0].text)
        
        // SCAN FLASH CARD


    }
    
    private func setupViewModel() {
        // REPOSITORIES
        let storyRepository = JSONStoryRepository()
        let backgroundRepository = JSONBackgroundRepository()
        let objectImageRepository = JSONObjectImageRepository()
        
        // USECASES
        let storyUsecase = StoryUsecase(storyRepository: storyRepository)
        let backgroundUsecase = BackgroundUsecase(backgroundRepository: backgroundRepository)
        let objectImageUsecase = ObjectImageUsecase(objectImageRepository: objectImageRepository)
        
        // INIT VIEW MODEL
        viewModel = StorybookViewModel(bookId: bookId, page: page, storyUsecase: storyUsecase, backgroundUsecase: backgroundUsecase, objectImageUsecase: objectImageUsecase)
        
        // GET THE DATA
        stories = viewModel.loadStories()
        images = viewModel.loadImage()
        imageScan = viewModel.loadScanableImage()
        backgroundImage = viewModel.loadBackgroundImages()
    }


    private func storyTextBeforeScan(text: String) {
        addStoryText(text: text)
    }
    
    private func addStoryText(text: String) {
        storyLabel = UILabel()
        storyLabel.text = text
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        storyLabel.numberOfLines = 0
        storyLabel.font = UIFont.systemFont(ofSize: 28)
        storyLabel.textColor = .black
        
        view.addSubview(storyLabel)

        NSLayoutConstraint.activate([
            storyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: stories[page].padding.top),
            storyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: stories[page].padding.left),
            storyLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: stories[page].padding.right)
        ])
    }
    
    private func loadImageAfterScan() {
        // INIT IMAGE
        for data in imageScan {
            let image = createImage(imageName: data.image)
            let label = createLabelImage(labelName: data.name)
            
            image.addSubview(label)
            view.addSubview(image)

            setupConstraint(
                image: image,
                top: data.padding.top,
                bottom: data.padding.bottom,
                right: data.padding.right,
                left: data.padding.left,
                height: data.size.height,
                width: data.size.width
            )
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: image.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: image.trailingAnchor),
                label.bottomAnchor.constraint(equalTo: image.bottomAnchor),
                label.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    private func loadImage() {
        // INIT IMAGE
        for data in images {
            let image = createImage(imageName: data.image)
            let label = createLabelImage(labelName: data.name)
            
            image.addSubview(label)
            view.addSubview(image)
            
            setupConstraint(
                image: image,
                top: data.padding.top,
                bottom: data.padding.bottom,
                right: data.padding.right,
                left: data.padding.left,
                height: data.size.height,
                width: data.size.width
            )
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: image.centerXAnchor),
                label.widthAnchor.constraint(equalTo: image.widthAnchor, constant: 200),
                label.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: 30),
                label.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        startLottie(x: 100, y: 100)
    }
    
    private func createImage(imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)

        return imageView
    }
    
    private func createLabelImage(labelName: String) -> UILabel {
        let label = UILabel()
        label.text = labelName
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true

        return label
    }
    
    private func setupNextPageButton() {
            nextPageButton = UIButton(type: .system)
            nextPageButton.setTitle("Halaman Berikutnya", for: .normal) // Set button title
            nextPageButton.setTitleColor(.white, for: .normal)
            nextPageButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            nextPageButton.layer.cornerRadius = 10
            nextPageButton.translatesAutoresizingMaskIntoConstraints = false
            
            nextPageButton.addTarget(self, action: #selector(nextPageTapped), for: .touchUpInside) // Set button action
            
            view.addSubview(nextPageButton)
            
            // Add constraints to position the button in the bottom-right corner
            NSLayoutConstraint.activate([
                nextPageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                nextPageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
                nextPageButton.widthAnchor.constraint(equalToConstant: 200),
                nextPageButton.heightAnchor.constraint(equalToConstant: 50)
            ])

            // //Setup button next page
            // let buttonNextPage = NextButtonComponent()
            
            // view.addSubview(buttonNextPage)
            
            // //TODO: Change constant to make it responsive
            // NSLayoutConstraint.activate([
            //     buttonNextPage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            //     buttonNextPage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            // ])
        }

}

// HELPER
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
    
    private func setupConstraint(image: UIImageView,top: Double, bottom: Double, right: Double, left: Double, height: Double, width: Double) {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
            image.widthAnchor.constraint(equalToConstant: width*0.8),
            image.heightAnchor.constraint(equalToConstant:height*0.8)

        ])
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
}


// HELPER ACTION SELECTOR GESTURE
extension StorybookViewController {
    @objc
    private func changeBackgroundImage() {
        self.background.removeFromSuperview()
//        self.storyLabel.removeFromSuperview()
        
        let newBackground = BackgroundViewComponent(image: UIImage(named: backgroundImage[1].image)!, frame: view.bounds)
        
        view.addSubview(newBackground)
        
        loadImage()
        
        setupNextPageButton()
//        self.addStoryText(text: stories[1].text)
    }
    
    @objc 
    private func nextPageTapped() {
        // Handle the logic to load the next page
        page += 1
        
        // You may want to update the background, images, and text for the next page here
        loadPage()
    }

    
    @objc 
    private func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }

        if !isImageScaled {
            
            if overlay == nil {
                overlay = UIView()
                overlay?.backgroundColor = UIColor.black
                overlay?.alpha = 0.7
                overlay?.translatesAutoresizingMaskIntoConstraints = false
                if let overlay = overlay {
                    view.addSubview(overlay)
                    
                    // Add constraints to cover the entire view
                    NSLayoutConstraint.activate([
                        overlay.topAnchor.constraint(equalTo: view.topAnchor),
                        overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                        overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                    ])
                }
            }

            // Bring the tapped image to the front
            view.bringSubviewToFront(tappedImageView)

            // Show or hide the label on the tapped image
            if let label = tappedImageView.subviews.compactMap({ $0 as? UILabel }).first {
                isLabelVisible.toggle()
                label.isHidden = !isLabelVisible
                UIView.animate(withDuration: 0.3) {
                    label.alpha = self.isLabelVisible ? 1 : 0
                }
            }

            // Scale the image
            UIView.animate(withDuration: 0.3, animations: {
                tappedImageView.transform = tappedImageView.transform.scaledBy(x: 1.2, y: 1.2)
            })

            isImageScaled = true
        } else {
            // Reset image scaling
            UIView.animate(withDuration: 0.3, animations: {
                tappedImageView.transform = .identity
            })

            // Remove the overlay
            UIView.animate(withDuration: 0.3, animations: {
                self.overlay?.alpha = 0
            }) { _ in
                self.overlay?.removeFromSuperview()
                self.overlay = nil
            }

            isImageScaled = false

            // Hide the label
            if let label = tappedImageView.subviews.compactMap({ $0 as? UILabel }).first {
                self.isLabelVisible = false
                UIView.animate(withDuration: 0.3) {
                    label.alpha = 0
                }
                label.isHidden = true
            }
        }
    }
}
