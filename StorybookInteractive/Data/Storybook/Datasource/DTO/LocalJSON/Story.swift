//
//  Story.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 19/08/24.
//

import Foundation

struct Story: Codable {
    let id, bookId: String
    let page: Int
    let text: String
    let padding: Padding
    let size: Size
    let voiceOverSound: String
}
