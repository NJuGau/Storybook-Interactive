//
//  StoryCoordinator.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 14/08/24.
//

import Foundation
import UIKit

class InteractionStoryBook: ObservableObject {
    @Published var isNextPage: Bool = false
    @Published var isScanCard: Bool = false
    @Published var isPopupImage: Bool = false
    @Published var isStoryText: Bool = true
}
