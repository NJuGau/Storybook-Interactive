//
//  BookViewController.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 20/08/24.
//

import Foundation
import UIKit

class BookViewController: UIViewController {
    private var currentPage = 1
    private let bookId = "37bff686-7d09-4e53-aa90-fb465da131b5"
    private var didPresentPage = false
    private var isNext = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup if needed
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Ensure the page is presented only once
        if !didPresentPage {
            presentStorybookPage(page: currentPage)
            didPresentPage = true
        }
    }

    func presentStorybookPage(page: Int) {
        let storybookViewController = StorybookViewController(bookId: bookId, page: currentPage)
        storybookViewController.delegate = self
        storybookViewController.page = page
        storybookViewController.bookId = bookId
        storybookViewController.modalPresentationStyle = .fullScreen
        storybookViewController.modalTransitionStyle = .crossDissolve
        
        // Present the storybook view controller
        self.present(storybookViewController, animated: true, completion: nil)
    }
    
    func presentEndScreen(completion: (() -> Void)? = nil) {
        let endViewController = TheEndScreenViewController()
        endViewController.modalPresentationStyle = .fullScreen
        
        self.present(endViewController, animated: true, completion: completion)
    }

    @objc 
    func nextPage() {
        currentPage += 1
        presentStorybookPage(page: currentPage)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
}


extension BookViewController: StorybookViewControllerDelegate {
    func didRequestNextPage(totalPage: Int) -> Bool {
        if currentPage == totalPage {
            return false
        }
        return true
    }
    
    func didRequestCurrentPageNumber() -> Int {
        return self.currentPage
    }
}
