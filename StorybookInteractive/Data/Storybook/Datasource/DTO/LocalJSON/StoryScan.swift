//
//  StoryScan.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 21/08/24.
//

import Foundation

struct StoryScan: Codable {
    let id, bookId: String
    let page: Int
    let scanCard: String
}
