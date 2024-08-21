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

    private func presentStorybookPage(page: Int) {
        let storybookViewController = StorybookViewController(bookId: bookId, page: currentPage)
        storybookViewController.page = page
        storybookViewController.bookId = bookId
        storybookViewController.modalPresentationStyle = .fullScreen
        
        // Present the storybook view controller
        self.present(storybookViewController, animated: true, completion: nil)
    }

    @objc 
    func nextPage() {
        currentPage += 1
        presentStorybookPage(page: currentPage)
    }
}


extension BookViewController: StorybookViewControllerDelegate {
    func didRequestNextPage() {
        nextPage()
    }
}