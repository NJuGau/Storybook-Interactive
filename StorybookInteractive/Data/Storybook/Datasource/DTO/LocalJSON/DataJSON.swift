//
//  Story.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 14/08/24.
//

import Foundation

struct Book: Codable {
    var id: Int
    var title: String
    var listStory: [StoryPage]
}

struct StoryPage: Codable {
    var id: Int
    var listTextStory: [TextStory]
    var backgroundImage: [String]
    var backgroundSound: [String]
    var scanCardClassifier: String
    var listInteractiveObject: [InteractiveObject]
}

struct TextStory: Codable {
    var id: Int
    var text: String
    var padding: Padding
}

struct Size: Codable {
    var width: Double
    var height: Double
}

struct InteractiveObject: Codable {
    var id: Int
    var objectImage: String
    var objectSound: String
    var padding: Padding
    var size: Size
}

struct Padding: Codable {
    var top: Double
    var bottom: Double
    var left: Double
    var right: Double
}
