//
//  FirstPageViewController.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 13/08/24.
//

import Foundation
import UIKit


protocol StorybookViewControllerDelegate: AnyObject {
    func didRequestNextPage()
    func didRequestCurrentPageNumber() -> Int
}

class StorybookViewController: UIViewController {
    
    var page = 7
    var bookId = "37bff686-7d09-4e53-aa90-fb465da131b5"

    weak var delegate: StorybookViewControllerDelegate?

        
    private var viewModel: StorybookViewModel!
    private var background: UIImageView!
    private var storyLabel: UILabel!
    private var stories: [Story] = []
    private var images: [ObjectImage] = []
    private var imageScan: [ObjectImage] = []
    private var backgroundImage: [Background] = []
    private var bookDetail: Book!
    private var isScan = false
    
    private var scanningView: ScanningViewController?
    private var repeatView: RepeatViewController?
    
    private var isImageScaled = false
    private var overlay: UIView?
    private var isLabelVisible = false

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
        
        // ADD TAP GESTURE
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeBackgroundImage))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func loadPage(){
        // Load background
        background = BackgroundViewComponent(image: UIImage(named: backgroundImage[0].image)!, frame: view.bounds)
        view.addSubview(background)
        
        
        // LOAD IMAGE AFTER SCAN
        
        // Load story text
//        storyTextBeforeScan(text: stories[0].text)
        
        // SCAN FLASH CARD
        setupScanView()

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
    }
    
    private func setupNextPageButton() {
        let buttonNextPage = NextButtonComponent()
        buttonNextPage.addTarget(self, action: #selector(nextPageTapped), for: .touchUpInside)
        
        view.addSubview(buttonNextPage)
        
        NSLayoutConstraint.activate([
         buttonNextPage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
         buttonNextPage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
        ])
    }

}

// HELPER
extension StorybookViewController {
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
    
    private func createStoryTextLabel(text: String) {
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
    private func changeBackgroundImage() {
        self.background.removeFromSuperview()
//        self.storyLabel.removeFromSuperview()
        
        let newBackground = BackgroundViewComponent(image: UIImage(named: backgroundImage[1].image)!, frame: view.bounds)
        
        view.addSubview(newBackground)
        
        if page < bookDetail.totalPage {
            setupNextPageButton()
        }
        
        loadImage()
        
//        self.addStoryText(text: stories[1].text)
    }
    
    @objc 
    private func nextPageTapped() {
        if let parent = self.presentingViewController as? BookViewController {
//             // Memicu method nextPage di BookViewController
            
            delegate?.didRequestNextPage()
            dismiss(animated: true, completion: nil)
            parent.nextPage()
        }
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

// HELPER FOR SCAN OVERLAY VIEW
extension StorybookViewController: ScanningDelegate {
    func setupScanView() {
        if let currentPageNumber: Int = delegate?.didRequestCurrentPageNumber() {
            let prompt = viewModel.getScanCardForByPage(bookId: bookId, page: currentPageNumber)
            scanningView = ScanningViewController(promptText: prompt.scanCard)
            scanningView?.delegate = self
            view.addSubview(scanningView?.view ?? UIView())
        }
    }
    
    func didScanCompleteDelegate(_ controller: ScanningViewController, didCaptureResult identifier: String) {
        if let currentPageNumber: Int = delegate?.didRequestCurrentPageNumber() {
            let prompt = viewModel.getScanCardForByPage(bookId: bookId, page: currentPageNumber)
            if prompt.scanCard == identifier {
                removeScanningView()
                setupRepeatView(cardImageName: prompt.scanCard)
            }
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
        print("touch close")
        // TODO: implement stop dialogue sound if any
        removeRepeatView()
        loadImageAfterScan()
    }
    
    func didPressCardDelegate(_ controller: RepeatViewController) {
        // TODO: implement repeat sound for cards
        print("touch repeat")
    }
    
    func setupRepeatView(cardImageName: String) {
        DispatchQueue.main.async { [weak self] in
            self?.repeatView = RepeatViewController(cardImageName: cardImageName)
            self?.repeatView?.delegate = self
            self?.view.addSubview(self?.repeatView?.view ?? UIView())
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
