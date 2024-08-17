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
    var backgroundImage: String
    var backgroundSound: String
    var scanCardClassifier: String
    var listInteractiveObject: [InteractiveObject]
}

struct TextStory: Codable {
    var id: Int
    var text: String
    var position: Position
}

struct Position: Codable {
    var xPosition: Double
    var yPosition: Double
    var width: Double
    var height: Double
}

struct InteractiveObject: Codable {
    var id: Int
    var objectImage: String
    var objectSound: String
    var position: Position
}
