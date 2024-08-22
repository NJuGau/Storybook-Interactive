//
//  ObjectImage.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 19/08/24.
//

import Foundation

struct ObjectImage: Codable {
    let id, bookId: String
    let page: Int
    let name: String
    let image: String
    let isScan: Bool
    let padding: Padding
    let size: Size
    let wordTruncationSound: String
}
