//
//  FirstPageViewController.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 13/08/24.
//

import Foundation
import UIKit
import AVFAudio

enum SoundStoryState {
    case openingStory, scanGuidance, cardResult, continueStory, interactiveObject, idle
}

protocol StorybookViewControllerDelegate: AnyObject {
    func didRequestNextPage(totalPage: Int) -> Bool
    func didRequestCurrentPageNumber() -> Int
}

class StorybookViewController: UIViewController, SoundDelegate {
    
    var page = 1
    var bookId = "37bff686-7d09-4e53-aa90-fb465da131b5"

    weak var delegate: StorybookViewControllerDelegate?

    private var isInteractable = false
    private var homeButton: UIButton?
    private var vignetteOverlay: UIView?
    private var nextButton: UIButton?
    private var viewModel: StorybookViewModel!
    private var background: UIImageView!
    private var storyLabel: UILabel!
    private var stories: [Story] = []
    private var images: [ObjectImage] = []
    private var imageScan: [ObjectImage] = []
    private var backgroundImage: [Background] = []
    private var bookDetail: Book!
    private var storyScanCard: StoryScan?
    private var imageLabel: String?
    private var isScan = false
    private var listInteractiveObject: [UIImageView] = []
    
    private var scanningView: ScanningViewController?
    private var repeatView: RepeatViewController?
    
    private var isImageScaled = false
    private var overlay: UIView?
    private var isLabelVisible = false
    
    private let soundManager: SoundManager = SoundManager.shared
    private var soundStoryState: SoundStoryState = .idle {
        didSet {
            checkSoundStoryState()
        }
    }

    init(bookId: String, page: Int) {
        self.bookId = bookId
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // SETUP VIEW MODEL
        setupViewModel()
        
        loadPage()

        home()
        // LOAD STORY TEXT BEFORE SCAN
//        createStoryTextLabel(data: stories[0])     
        
        let vignetteView = createVignetteView()
        vignetteOverlay = vignetteView
        view.addSubview(vignetteView)
            
            NSLayoutConstraint.activate([
                vignetteView.topAnchor.constraint(equalTo: view.topAnchor),
                vignetteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                vignetteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                vignetteView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        if let button = homeButton {
            view.bringSubviewToFront(button)
        }
    }
    
    private func loadPage(){
        // Load background
        background = BackgroundViewComponent(image: UIImage(named: backgroundImage[0].image)!, frame: view.bounds)
        view.addSubview(background)
        
        // Load background sound
        soundManager.delegate = self
        setAndPlayBackgroundSound(backgroundSound: backgroundImage[0].backgroundSound)
        soundStoryState = .openingStory
    }
    
    private func home() {
        let homeButton = ButtonComponent().homeButton
        self.homeButton = homeButton
        view.addSubview(homeButton)
        
        NSLayoutConstraint.activate([
            homeButton.widthAnchor.constraint(equalToConstant: 69),
            homeButton.heightAnchor.constraint(equalToConstant: 69),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 43),
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
        ])
        
        view.bringSubviewToFront(homeButton)
        
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func homeButtonTapped() {
        quitToTitleAlert()
    }
    
    private func createVignetteView() -> UIView {
        let vignetteView = UIView(frame: self.view.bounds)
        vignetteView.translatesAutoresizingMaskIntoConstraints = false
        vignetteView.isUserInteractionEnabled = false
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = vignetteView.bounds
        
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.6).cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.6).cgColor
        ]
        
        gradientLayer.locations = [0.0, 0.2, 0.8, 1.0]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        vignetteView.layer.addSublayer(gradientLayer)
        
        return vignetteView
    }

    
    func quitToTitleAlert() {
            let alertController = UIAlertController(
                title: "Kembali ke beranda?",
                message: "Progessmu tidak akan disimpan dan akan kehilangan kemajuan saat ini. Tetap kembali ke beranda?",
                preferredStyle: .alert
            )

                let quitAction = UIAlertAction(title: "Ya", style: .default) { _ in
                    self.quitToTitle()
            }
            alertController.addAction(quitAction)

            let cancelAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            self.present(alertController, animated: true, completion: nil)
    }
    
    func quitToTitle() {
        //TODO: Deprecated, this was a hotfix
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                self.soundManager.stopDialogueSound()
                self.soundManager.stopBackgroundSound()
                let letsReadViewController = LetsReadViewController()
                letsReadViewController.modalPresentationStyle = .fullScreen
                
                window.rootViewController = letsReadViewController
                
                UIView.transition(with: window, duration: 0.5, options: .transitionCurlUp, animations: nil, completion: nil)
            } else {
                print("No key window found")
            }
    }
    
    private func setupViewModel() {
        // REPOSITORIES
        let bookRepository = JSONBookRepository()
        let storyRepository = JSONStoryRepository()
        let backgroundRepository = JSONBackgroundRepository()
        let objectImageRepository = JSONObjectImageRepository()
        let storyScanRepository = JSONStoryScanRepository()
        
        // USECASES
        let bookUsecase = BookUsecase(bookRepository: bookRepository)
        let storyUsecase = StoryUsecase(storyRepository: storyRepository)
        let backgroundUsecase = BackgroundUsecase(backgroundRepository: backgroundRepository)
        let objectImageUsecase = ObjectImageUsecase(objectImageRepository: objectImageRepository)
        let storyScanUsecase = StoryScanUsecase(storyScanRepository: storyScanRepository)
        
        // INIT VIEW MODEL
        viewModel = StorybookViewModel(bookId: bookId, page: page, bookUsecase: bookUsecase,storyUsecase: storyUsecase, backgroundUsecase: backgroundUsecase, objectImageUsecase: objectImageUsecase, storyScanUsecase: storyScanUsecase)
        
        // GET THE DATA
        bookDetail = viewModel.loadBookDetail()
        stories = viewModel.loadStories()
        images = viewModel.loadImage()
        imageScan = viewModel.loadScanableImage()
        backgroundImage = viewModel.loadBackgroundImages()
        storyScanCard = viewModel.getScanCardForByPage()
    }
    
    private func loadImageAndSoundAfterScan() {
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
                
        self.background.removeFromSuperview()
        
        let newBackground = BackgroundViewComponent(image: UIImage(named: backgroundImage[1].image)!, frame: view.bounds)
        
        view.addSubview(newBackground)
        
        if page <= bookDetail.totalPage {
            setupNextPageButton()
        }
        
        loadImage()

        soundStoryState = .continueStory
        
        if let vignette = vignetteOverlay {
            view.bringSubviewToFront(vignette)
        }
        if let button = homeButton {
            view.bringSubviewToFront(button)
        }
        if let button = nextButton {
            view.bringSubviewToFront(button)
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
    }
    
    // Set up audio/sound
    private func setAndPlayBackgroundSound(backgroundSound: String){
        soundManager.setupBackgroundSound(soundName: backgroundSound)
        soundManager.playBackgroundSound()
    }
    
    private func setAndPlayDialogueSound(soundName: String){
        soundManager.setupDialogueSound(soundName: soundName)
        soundManager.playDialogueSound()
    }
    
    func checkSoundStoryState() {
        switch soundStoryState {
            case .openingStory:
                setAndPlayDialogueSound(soundName: stories[0].voiceOverSound)
                createStoryTextLabel(data: stories[0])
            case .scanGuidance:
                setAndPlayDialogueSound(soundName: storyScanCard!.scanGuidanceSound)
            case .cardResult:
                setAndPlayDialogueSound(soundName: SoundPath.feedbackHebat)
            case .continueStory:
                setAndPlayDialogueSound(soundName: stories[1].voiceOverSound)
                createStoryTextLabel(data: stories[1])
            case .interactiveObject:
                setAndPlayDialogueSound(soundName: "Word Truncation - \(imageLabel ?? "")")
            case .idle:
                return
            }
    }
    
    func audioDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        switch soundStoryState {
            case .openingStory:
                // SCAN FLASH CARD
                setupScanView()
                soundStoryState = .idle
            case .cardResult:
                soundStoryState = .idle
                setAndPlayDialogueSound(soundName: storyScanCard!.wordTruncationSound)
            case .continueStory:
                for item in listInteractiveObject {
                    popupAnimation(image: item)
                }
                isInteractable = true
                soundStoryState = .idle
            default:
                soundStoryState = .idle
        }
       
    }
    
    private func setupNextPageButton() {
        let buttonNextPage = NextButtonComponent()
        buttonNextPage.addTarget(self, action: #selector(nextPageTapped), for: .touchUpInside)
        
        nextButton = buttonNextPage
        
        view.addSubview(buttonNextPage)
        
        NSLayoutConstraint.activate([
         buttonNextPage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
         buttonNextPage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
        ])
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
            image.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            image.layer.removeAllAnimations()
            image.transform = CGAffineTransform(scaleX: 1, y: 1)
        }

    }
    
    private func createImage(imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)
        
        listInteractiveObject.append(imageView)
        
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
    
    private func createStoryTextLabel(data: Story) {
        storyLabel = UILabel()
        storyLabel.text = data.text
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        storyLabel.numberOfLines = 0
        
        guard let customFont = UIFont(name: "Nunito-Bold", size: 22) else {
            fatalError("""
                Failed to load the "Nunito-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        storyLabel.font = customFont
        
        storyLabel.textColor = .white
        storyLabel.textAlignment = .left
        storyLabel.adjustsFontSizeToFitWidth = true
        
        storyLabel.layer.shadowColor = UIColor.black.cgColor
        storyLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        storyLabel.layer.shadowOpacity = 0.8
        storyLabel.layer.shadowRadius = 4

        storyLabel.layer.shouldRasterize = true
        storyLabel.layer.rasterizationScale = UIScreen.main.scale
        
        view.addSubview(storyLabel)
        
        NSLayoutConstraint.activate([
            storyLabel.widthAnchor.constraint(equalToConstant: data.size.width),
            storyLabel.heightAnchor.constraint(equalToConstant: data.size.height),
            storyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: data.padding.left),
            storyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: data.padding.top),
        ])
    }
    
    private func setupConstraint(image: UIImageView,top: Double, bottom: Double, right: Double, left: Double, height: Double, width: Double) {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
            image.widthAnchor.constraint(equalToConstant: width),
            image.heightAnchor.constraint(equalToConstant:height)

        ])
    }
}


// HELPER ACTION SELECTOR GESTURE
extension StorybookViewController {
    @objc
    func changeBackgroundImage() {
        self.background.removeFromSuperview()
        
        let newBackground = BackgroundViewComponent(image: UIImage(named: backgroundImage[1].image)!, frame: view.bounds)
        
        view.addSubview(newBackground)
        
        if page < bookDetail.totalPage {
            setupNextPageButton()
        }
        
        loadImage()
    }
    
    @objc 
    private func nextPageTapped() {
        if let parent = self.presentingViewController as? BookViewController {
                if let bookDelegate = delegate {
                    if bookDelegate.didRequestNextPage(totalPage: bookDetail.totalPage){
                        // Move to the next page
                        soundManager.stopBackgroundSound()
                        soundManager.stopDialogueSound()
                        dismiss(animated: true) {
                            parent.nextPage()
                        }
                    } else {
                        // Present the end screen
                        soundManager.stopDialogueSound()
                        soundManager.stopBackgroundSound()
                        dismiss(animated: true) { [weak self] in
                            parent.presentEndScreen {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    self?.quitToTitle()
                                }
                            }
                        }
                    }
                }
            }
    }
    
    @objc 
    private func imageTapped(_ sender: UITapGestureRecognizer) {
        guard isInteractable else { return }
        guard let tappedImageView = sender.view as? UIImageView else { return }
        
        if let label = tappedImageView.subviews.first(where: { $0 is UILabel }) as? UILabel {
            print("Label text: \(label.text ?? "No text")")
            imageLabel = label.text
            soundStoryState = .interactiveObject
        }
        
        if !isImageScaled {
            
            if overlay == nil {
                overlay = UIView()
                overlay?.backgroundColor = UIColor.black
                overlay?.alpha = 0.7
                overlay?.translatesAutoresizingMaskIntoConstraints = false
                if let overlay = overlay {
                    view.addSubview(overlay)
                    
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

// HELPER FOR SCAN OVERLAY VIEW
extension StorybookViewController: ScanningDelegate {
    func setAndPlayScanGuidanceSound() {
        soundStoryState = .scanGuidance
    }
    
    func setupScanView() {
        scanningView = ScanningViewController(promptText: storyScanCard!.scanCard)
        scanningView?.delegate = self
        view.addSubview(scanningView?.view ?? UIView())
    }
    
    func didScanCompleteDelegate(_ controller: ScanningViewController, didCaptureResult identifier: String) {
        if storyScanCard!.scanCard == identifier {
            removeScanningView()
            setupRepeatView(cardImageName: storyScanCard!.scanCard)
        }
    }
    
    func removeScanningView() {
        DispatchQueue.main.async { [weak self] in
            self?.scanningView?.videoHandler.stop()
            self?.scanningView?.view.removeFromSuperview()
            self?.scanningView = nil
        }
    }
}

// HELPER FOR REPEATVIEW
extension StorybookViewController: RepeatDelegate {
    
    func didPressCloseDelegate(_ controller: RepeatViewController) {
        soundManager.stopDialogueSound()
        removeRepeatView()
        loadImageAndSoundAfterScan()
    }
    
    func didPressCardDelegate(_ controller: RepeatViewController) {
        // TODO: implement repeat sound for cards
    }
    
    func setupRepeatView(cardImageName: String) {
        DispatchQueue.main.async { [weak self] in
            self?.repeatView = RepeatViewController(cardImageName: cardImageName)
            self?.repeatView?.delegate = self
            self?.view.addSubview(self?.repeatView?.view ?? UIView())
            self?.soundStoryState = .cardResult
        }
    }
    
    func removeRepeatView() {
        DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                // Remove the view
                strongSelf.repeatView?.view.removeFromSuperview()
                strongSelf.repeatView = nil
                
                // Force layout update
                strongSelf.view.setNeedsLayout()
                strongSelf.view.layoutIfNeeded()
                
            }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
}
